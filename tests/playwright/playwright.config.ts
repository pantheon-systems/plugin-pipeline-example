import { defineConfig, devices } from '@playwright/test';
import { defineBddConfig } from 'playwright-bdd';
import * as dotenv from 'dotenv';

dotenv.config();

const testDir = defineBddConfig({
  features: 'features/**/*.feature',
  steps: [
    'steps/**/*.ts',
    'node_modules/cms-bdd/dist/fixtures/customFixtures.js',
  ],
});

const headless = process.env.HEADLESS !== 'false';
const slowMo = parseInt(process.env.SLOW_MO || '0');

export default defineConfig({
  globalSetup: './global-setup.ts',
  globalTeardown: './global-teardown.ts',
  testDir,
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: 1,
  reporter: [
    ['html'],
    ['list'],
  ],
  timeout: 300000,
  use: {
    // Local-dev convenience only. This is resolved once when the config module
    // loads, before globalSetup creates the multidev, so it's frozen at whatever
    // WP_URL was set at process start. Step definitions read `process.env.WP_URL`
    // directly at call time instead of relying on Playwright's baseURL resolution,
    // since globalSetup updates that env var (and Playwright forks test workers
    // after globalSetup runs, so they inherit the updated value) but this frozen
    // config value would not reflect it.
    baseURL: process.env.WP_URL,
    headless,
    launchOptions: {
      slowMo,
    },
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    // Always record, not just on failure -- the spike's acceptance criterion is
    // "test execution is recorded as a video", not "on failure only".
    video: 'on',
    actionTimeout: 10000,
    navigationTimeout: 30000,
  },
  projects: [
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
        viewport: { width: 1920, height: 1080 },
      },
    },
  ],
});
