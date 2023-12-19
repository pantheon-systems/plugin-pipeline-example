const test = require("node:test");
const assert = require("node:assert");

[
  {
    name: "dev changelog",
    path: "./scripts/tests/fixtures/dev.md",
    expected: `* Set Counter to 1 [[34](https://github.com/pantheon-systems/plugin-pipeline-example/pull/34)]
* Set Counter to 2 [[36](https://github.com/pantheon-systems/plugin-pipeline-example/pull/36)]`,
  },
  {
    name: "release changelog",
    path: "./scripts/tests/fixtures/release.md",
    expected: `* Set Counter to 1 [[34](https://github.com/pantheon-systems/plugin-pipeline-example/pull/34)]
* Set Counter to 2 [[36](https://github.com/pantheon-systems/plugin-pipeline-example/pull/36)]`,
  },
].map(({ name, path, expected }) => {
  test(name, () => {
    process.argv[2] = path;
    const actual = require("../get_release_notes");
    console.log(actual);
    assert.equal(actual, expected);
  });
});
