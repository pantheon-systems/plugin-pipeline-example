import { execSync } from 'child_process';
import * as path from 'path';
import { terminusExec } from 'cms-bdd';

// cms-bdd covers multidev create/delete, connection-mode switching, and
// workflow polling. It doesn't ship an SFTP file-push helper, since that's
// specific to each consumer's plugin/module layout -- adapted here from the
// working pattern in pantheon-mu-plugin PR #119 (tests/e2e/lib/pantheon.ts).

const PLUGIN_SLUG = 'rossums-universal-robots';
const REMOTE_PLUGIN_DIR = `code/wp-content/plugins/${PLUGIN_SLUG}`;

// Repo root, so sftp `put` commands can use plain repo-relative local paths
// regardless of the Playwright process's own working directory.
const REPO_ROOT = path.resolve(__dirname, '..', '..', '..');

function assertSafeName(kind: string, value: string): string {
  if (!/^[a-z0-9][a-z0-9.-]*$/i.test(value)) {
    throw new Error(`Unsafe ${kind}: ${JSON.stringify(value)}`);
  }
  return value;
}

/** Run a batch of sftp commands against a site.env (non-interactive). */
function sftpBatch(siteEnv: string, commands: string[]): void {
  assertSafeName('site.env', siteEnv);
  const sftpCmd = terminusExec(`connection:info ${siteEnv} --field=sftp_command`, 60000).trim();
  const sftpWithOpts = sftpCmd.replace(
    /^sftp /,
    'sftp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -b - '
  );
  execSync(sftpWithOpts, {
    cwd: REPO_ROOT,
    input: [...commands, 'bye'].join('\n'),
    stdio: ['pipe', 'pipe', 'pipe'],
    timeout: 120000,
  });
}

/**
 * SFTP the plugin's release files (the same files .distignore keeps for the
 * WordPress.org package -- see build-tag-release.yml) onto a fresh multidev.
 */
export function installBranchPlugin(siteEnv: string): void {
  sftpBatch(siteEnv, [
    `mkdir ${REMOTE_PLUGIN_DIR}`,
    `put rossums-universal-robots.php ${REMOTE_PLUGIN_DIR}/rossums-universal-robots.php`,
    `put readme.txt ${REMOTE_PLUGIN_DIR}/readme.txt`,
    `put -r assets ${REMOTE_PLUGIN_DIR}/assets`,
  ]);
}
