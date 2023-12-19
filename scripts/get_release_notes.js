"use strict";
const { readFileSync } = require("fs");
const { resolve } = require("path");

// get the args
const [path] = process.argv.slice(2);
// throw if necessary args are missing
if (!path) {
  throw new Error("Please provide a path to the file to parse");
}
const filePath = resolve(__dirname, "..", path);
const fileContent = readFileSync(filePath, "utf8");
/**
 * The following input:
 *
 * ### 0.1.3-dev
 * * Set Counter to 1 [20](https://github.com/pantheon-systems/plugin-pipeline-example/pull/20)
 * ### 0.1.2-dev (18 December 2023)
 * * Set Counter to 0 [19](https://github.com/pantheon-systems/plugin-pipeline-example/pull/19)
 *
 * would have the following match:
 * * Set Counter to 1 [20](https://github.com/pantheon-systems/plugin-pipeline-example/pull/20)
 */
const regex =
  /(^#{3}\s[\s\d\.]+(\([\w\d\s]+\))?$\n(?<notes>^[\w\d\W][^#]{3,}$\n))/gm;
const matches = fileContent.matchAll(regex);
const [releaseNotes] = [...matches].map((match) => match.groups.notes.trim());
console.log(releaseNotes);
