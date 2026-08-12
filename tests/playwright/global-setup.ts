import * as fs from 'fs';
import * as path from 'path';
import { execSync } from 'child_process';
import {
  terminusExec,
  generateMultidevName,
  getSiteEnv,
  ensureConnectionMode,
  waitForWorkflows,
} from 'cms-bdd';
import { installBranchPlugin } from './lib/deploy';

const STATE_FILE = path.join(__dirname, '.test-state.json');
const ADMIN_USER = 'pantheon';
const PLUGIN_SLUG = 'rossums-universal-robots';

async function globalSetup(): Promise<void> {
  const baseSite = process.env.TERMINUS_SITE || 'wp-test-august';

  const multidevName = generateMultidevName();
  console.log(`[setup] Creating multidev ${multidevName} on ${baseSite}...`);
  terminusExec(`multidev:create ${baseSite}.dev ${multidevName}`, 600000);

  const wpUrl = `https://${multidevName}-${baseSite}.pantheonsite.io`;
  const siteEnv = getSiteEnv(wpUrl, baseSite);

  console.log('[setup] Waiting for workflows to settle...');
  // wp-test-august is a shared fixture site, so this can also see workflows
  // from other repos' concurrent CI runs, not just this multidev's create.
  await waitForWorkflows(baseSite);

  console.log('[setup] Switching to SFTP and deploying the plugin...');
  await ensureConnectionMode('sftp', wpUrl);
  installBranchPlugin(siteEnv);

  console.log('[setup] Activating the plugin and setting a fresh admin password...');
  const adminPassword = execSync('openssl rand -hex 8').toString().trim();
  terminusExec(`wp ${siteEnv} -- plugin activate ${PLUGIN_SLUG}`, 60000);
  terminusExec(`wp ${siteEnv} -- user update ${ADMIN_USER} --user_pass=${adminPassword}`, 60000);

  // Playwright forks test workers after globalSetup returns, so they inherit
  // these env vars. See the comment on `use.baseURL` in playwright.config.ts
  // for why step definitions read these directly instead.
  process.env.WP_URL = wpUrl;
  process.env.WP_USER = ADMIN_USER;
  process.env.WP_PASSWORD = adminPassword;

  fs.writeFileSync(
    STATE_FILE,
    JSON.stringify({ multidevName, url: wpUrl, siteEnv, siteName: baseSite }, null, 2)
  );

  console.log(`[setup] Multidev ready at ${wpUrl}`);
}

export default globalSetup;
