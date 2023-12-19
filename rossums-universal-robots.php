<?php
/**
 * Plugin Name:     Rossums Universal Robots
 * Plugin URI:      pantheon.io
 * Description:     A demo plugin to test and showcase github actions during plugin development and release
 * Author:          Pantheon Systems Inc
 * Author URI:      pantheon.io
 * Text Domain:     rossums-universal-robots
 * Domain Path:     /languages
 * Version:         0.2.0-dev
 *
 * @package         Rossums_Universal_Robots
 */

/**
 * Returns an int. It's a feature.
 *
 * @return int An integer.
 * @since 0.1.1
 */
function rur_counter() {
	return 4;
}

/**
 * Returns a different int. It's another feature.
 *
 * @return int An integer.
 * @since 0.2.0-dev
 */
function rur_another_counter() {
    return 0;
}
