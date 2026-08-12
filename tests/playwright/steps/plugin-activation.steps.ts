import { createBdd } from 'playwright-bdd';
import { test, expect } from 'cms-bdd';

const { Given, When, Then } = createBdd(test);

Given('I am logged in to the WordPress site', async ({ wpLoginPage }) => {
  await wpLoginPage.login();
});

// Built from process.env.WP_URL directly (set by global-setup.ts once the
// multidev exists) rather than Playwright's baseURL, which is frozen at
// config-load time before the multidev is created -- see playwright.config.ts.
When('I navigate to {string}', async ({ page }, path: string) => {
  await page.goto(`${process.env.WP_URL}${path}`);
});

Then('I should see {string}', async ({ page }, text: string) => {
  await expect(page.locator('body')).toContainText(text);
});

Then('the URL should contain {string}', async ({ page }, fragment: string) => {
  expect(page.url()).toContain(fragment);
});
