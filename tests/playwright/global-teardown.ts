import * as fs from 'fs';
import * as path from 'path';
import { execSync } from 'child_process';

const STATE_FILE = path.join(__dirname, '.test-state.json');

function terminusExec(command: string, timeout = 120000): string {
  return execSync(`terminus ${command}`, {
    encoding: 'utf-8',
    timeout,
    stdio: ['pipe', 'pipe', 'pipe'],
  }).trim();
}

async function globalTeardown(): Promise<void> {
  if (process.env.SKIP_MULTIDEV === 'true') {
    console.log('[teardown] SKIP_MULTIDEV=true, skipping cleanup');
    return;
  }

  try {
    const raw = fs.readFileSync(STATE_FILE, 'utf-8');
    const state = JSON.parse(raw);

    if (state.siteName && state.multidevName) {
      console.log(`[teardown] Deleting multidev: ${state.siteName}.${state.multidevName}`);
      terminusExec(
        `multidev:delete ${state.siteName}.${state.multidevName} --delete-branch -y`,
        120000
      );
      console.log('[teardown] Multidev deleted');
    }

    fs.unlinkSync(STATE_FILE);
  } catch (e: any) {
    console.log(`[teardown] Cleanup error (non-fatal): ${e.message}`);
  }
}

export default globalTeardown;
