const test = require("node:test");
const assert = require("node:assert");
// const get_release_notes = require("../get_release_notes");

test("gets notes with date", () => {
	process.argv[2] = "./scripts/tests/fixtures/with_date.md";
  const expected = `* Set Counter to 1 [[34](https://github.com/pantheon-systems/plugin-pipeline-example/pull/34)]
* Set Counter to 2 [[36](https://github.com/pantheon-systems/plugin-pipeline-example/pull/36)]`;
  const actual = require("../get_release_notes");

  assert(actual === expected);
});
test("gets notes with tag", () => {
	process.argv[2] = "./scripts/tests/fixtures/with_tag.md";
  const expected = `* Set Counter to 1 [[34](https://github.com/pantheon-systems/plugin-pipeline-example/pull/34)]
* Set Counter to 2 [[36](https://github.com/pantheon-systems/plugin-pipeline-example/pull/36)]`;
  const actual = require("../get_release_notes");

  assert(actual === expected);
});
test("gets notes with date and tag", () => {
	process.argv[2] = "./scripts/tests/fixtures/with_date_and_tag.md";
  const expected = `* Set Counter to 1 [[34](https://github.com/pantheon-systems/plugin-pipeline-example/pull/34)]
* Set Counter to 2 [[36](https://github.com/pantheon-systems/plugin-pipeline-example/pull/36)]`;
  const actual = require("../get_release_notes");

  assert(actual === expected);
});
