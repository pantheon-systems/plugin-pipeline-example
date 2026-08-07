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

function generateMultidevName(): string {
  const id = Math.random().toString(36).substring(2, 7);
  return `ci-${id}`;
}

async function waitForWorkflow(siteEnv: string, maxWaitMs = 300000): Promise<void> {
  const start = Date.now();
  const pollInterval = 15000;
  const [siteName, envName] = siteEnv.split('.');

  while (Date.now() - start < maxWaitMs) {
    try {
      const output = terminusExec(
        `workflow:list ${siteName} --fields=workflow,status,env --format=json`,
        30000
      );
      const workflows = JSON.parse(output);
      const envWorkflows = Object.values(workflows).filter(
        (w: any) => w.env === envName
      );
      const failed = envWorkflows.find((w: any) => w.status === 'failed');
      if (failed) {
        throw new Error(`Workflow failed on ${siteEnv}: ${(failed as any).workflow}`);
      }
      const running = envWorkflows.find((w: any) => w.status === 'running');
      if (!running) {
        console.log('[setup] No running workflows, environment ready');
        return;
      }
      console.log(`[setup] Workflow still running: ${(running as any).workflow}`);
    } catch (e: any) {
      if (e.message?.includes('Workflow failed')) throw e;
    }
    await new Promise(r => setTimeout(r, pollInterval));
  }
  throw new Error(`Timed out waiting for workflows on ${siteEnv}`);
}

async function globalSetup(): Promise<void> {
  if (process.env.SKIP_MULTIDEV === 'true') {
    console.log('[setup] SKIP_MULTIDEV=true, skipping multidev setup');
    return;
  }

  const baseSite = process.env.TERMINUS_SITE || 'wp-test-august';
  console.log(`[setup] Starting WordPress multidev setup for ${baseSite}...`);

  const multidevName = generateMultidevName();
  console.log(`[setup] Creating multidev: ${multidevName}`);

  terminusExec(`multidev:create ${baseSite}.dev ${multidevName}`, 600000);

  const siteEnv = `${baseSite}.${multidevName}`;
  console.log('[setup] Waiting for multidev to be ready...');
  await waitForWorkflow(siteEnv);

  const wpUrl = `https://${multidevName}-${baseSite}.pantheonsite.io`;
  process.env.WP_URL = wpUrl;

  fs.writeFileSync(STATE_FILE, JSON.stringify({
    multidevName,
    url: wpUrl,
    siteEnv,
    siteName: baseSite,
  }, null, 2));

  console.log(`[setup] WP_URL set to ${wpUrl}`);
  console.log(`[setup] State written to ${STATE_FILE}`);
  console.log('[setup] Multidev setup complete');
}

export default globalSetup;
