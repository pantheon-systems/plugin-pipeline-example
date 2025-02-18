=== Rossums Universal Robots ===
Contributors: [getpantheon](https://profiles.wordpress.org/getpantheon)
Donate link: https://example.com/
Tags: comments, spam
Requires at least: 4.5
Tested up to: 6.7.2
Requires PHP: 5.6
Stable tag: 0.3.10-dev
License: GPLv2 or later
License URI: https://www.gnu.org/licenses/gpl-2.0.html

Here is a short description of the plugin.  This should be no more than 150 characters.  No markup here.

== Description ==

This is the long description.  No limit, and you can use Markdown (as well as in the following sections).

For backwards compatibility, if this section is missing, the full length of the short description will be used, and
Markdown parsed.

A few notes about the sections above:

*   "Contributors" is a comma separated list of wp.org/wp-plugins.org usernames
*   "Tags" is a comma separated list of tags that apply to the plugin
*   "Requires at least" is the lowest version that the plugin will work on
*   "Tested up to" is the highest version that you've *successfully used to test the plugin*. Note that it might work on
higher versions... this is just the highest one you've verified.
*   Stable tag should indicate the Subversion "tag" of the latest stable version, or "trunk," if you use `/trunk/` for
stable.

    Note that the `readme.txt` of the stable tag is the one that is considered the defining one for the plugin, so
if the `/trunk/readme.txt` file says that the stable tag is `4.3`, then it is `/tags/4.3/readme.txt` that'll be used
for displaying information about the plugin.  In this situation, the only thing considered from the trunk `readme.txt`
is the stable tag pointer.  Thus, if you develop in trunk, you can update the trunk `readme.txt` to reflect changes in
your in-development version, without having that information incorrectly disclosed about the current stable version
that lacks those changes -- as long as the trunk's `readme.txt` points to the correct stable tag.

    If no stable tag is provided, it is assumed that trunk is stable, but you should specify "trunk" if that's where
you put the stable version, in order to eliminate any doubt.

== Installation ==

This section describes how to install the plugin and get it working.

e.g.

1. Upload `plugin-name.php` to the `/wp-content/plugins/` directory
1. Activate the plugin through the 'Plugins' menu in WordPress
1. Place `<?php do_action('plugin_name_hook'); ?>` in your templates

== Frequently Asked Questions ==

= A question that someone might have =

An answer to that question.

= What about foo bar? =

Answer to foo bar dilemma.

== Screenshots ==

1. This screen shot description corresponds to screenshot-1.(png|jpg|jpeg|gif). Note that the screenshot is taken from
the /assets directory or the directory that contains the stable readme.txt (tags or trunk). Screenshots in the /assets
directory take precedence. For example, `/assets/screenshot-1.png` would win over `/tags/4.3/screenshot-1.png`
(or jpg, jpeg, gif).
2. This is the second screen shot

== Changelog ==

= 0.3.10-dev =

= 0.3.9 (4 January 2024) =
* Set Counter to 14  [[70](https://github.com/pantheon-systems/plugin-pipeline-example/pull/70)]

= 0.3.8 (21 December 2023) =
* Set Counter to 13 [[67](https://github.com/pantheon-systems/plugin-pipeline-example/pull/67)]

= 0.3.7 (21 December 2023) =
* Update the Second Counter to 4 [[64](https://github.com/pantheon-systems/plugin-pipeline-example/pull/64)]

= 0.3.6 (21 December 2023) =
* Update the Second Counter to 3 [[62](https://github.com/pantheon-systems/plugin-pipeline-example/pull/62)]

= 0.3.5 (21 December 2023) =
* Set Counter to 11 [[#](https://github.com/pantheon-systems/plugin-pipeline-example/pull/#)]
* Set Counter to 10 [[#](https://github.com/pantheon-systems/plugin-pipeline-example/pull/#)]

= 0.3.4 (20 December 2023) =
* Set Counter to 9 [[#](https://github.com/pantheon-systems/plugin-pipeline-example/pull/#)]

= 0.3.3 (20 December 2023) =
* Set Counter to 8 [[55](https://github.com/pantheon-systems/plugin-pipeline-example/pull/55)]

= 0.3.2 (20 December 2023) =
* Set Counter to 7 [[52](https://github.com/pantheon-systems/plugin-pipeline-example/pull/52)]

= 0.3.1 (20 December 2023) =
* Set Counter to 6 [[49](https://github.com/pantheon-systems/plugin-pipeline-example/pull/49)]

= 0.3.0 (20 December 2023) =
* Set Second Counter to 2 [[#](https://github.com/pantheon-systems/plugin-pipeline-example/pull/#)]
* Add RUR_VERSION Constant [[#](https://github.com/pantheon-systems/plugin-pipeline-example/pull/#)]

= 0.2.2 (20 December 2023) =
* Set Second Counter to 1 [[44](https://github.com/pantheon-systems/plugin-pipeline-example/pull/44)]

= 0.2.1 (20 December 2023) =
* Set Counter to 5 [[#](https://github.com/pantheon-systems/plugin-pipeline-example/pull/#)]

= 0.2.0 (19 December 2023) =
* Set Counter to 4 [[37](https://github.com/pantheon-systems/plugin-pipeline-example/pull/37)]
* Add another counter [[37](https://github.com/pantheon-systems/plugin-pipeline-example/pull/37)]

= 0.1.3 (19 December 2023) =
* Set Counter to 3 [[37](https://github.com/pantheon-systems/plugin-pipeline-example/pull/37)]

= 0.1.2 (19 December 2023) =
* Set Counter to 1 [[34](https://github.com/pantheon-systems/plugin-pipeline-example/pull/34)]
* Set Counter to 2 [[36](https://github.com/pantheon-systems/plugin-pipeline-example/pull/36)]

= 0.1.1 (18 December 2023) =
* Set Counter to 0 [[19](https://github.com/pantheon-systems/plugin-pipeline-example/pull/19)]

= 0.1.0 (6 June 2023) =
* Initial Release [[1](https://github.com/pantheon-systems/plugin-pipeline-example/pull/1)]

== Arbitrary section ==

You may provide arbitrary sections, in the same format as the ones above.  This may be of use for extremely complicated
plugins where more information needs to be conveyed that doesn't fit into the categories of "description" or
"installation."  Arbitrary sections will be shown below the built-in sections outlined above.

== A brief Markdown Example ==

Ordered list:

1. Some feature
1. Another feature
1. Something else about the plugin

Unordered list:

* something
* something else
* third thing

Here's a link to [WordPress](https://wordpress.org/ "Your favorite software") and one to [Markdown's Syntax Documentation][markdown syntax].
Titles are optional, naturally.

[markdown syntax]: https://daringfireball.net/projects/markdown/syntax
            "Markdown is what the parser uses to process much of the readme file"

Markdown uses email style notation for blockquotes and I've been told:
> Asterisks for *emphasis*. Double it up  for **strong**.

`<?php code(); // goes in backticks ?>`
