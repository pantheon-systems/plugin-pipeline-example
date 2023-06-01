module.exports = function( grunt ) {
	'use strict';
	const sass = require( 'node-sass' );
	// Project configuration
	grunt.initConfig( {
		pkg:    grunt.file.readJSON( 'package.json' ),

      /**
       * Clean up the JavaScript
       */
      jshint : {
          options : {
              jshintrc : true
          },
          all: ['assets/js/src/admin.js','assets/js/src/main.js']
      },

      /**
       * Processes and compresses JavaScript.
       */
      uglify : {

          backend : {

              options : {
                  beautify         : false,
                  preserveComments : false,
              },

              files : {
                  'assets/js/admin.min.js' : [
	                  'assets/js/src/admin.js'
                  ]
              }
          },
          frontend : {

              options : {
                  beautify         : false,
                  preserveComments : false,
              },

              files : {
                  'assets/js/main.min.js' : [
                      'assets/js/src/main.js'
                  ]
              }
          }

      },

      /**
       * Auto-prefix CSS Elements after SASS is processed.
       */
      autoprefixer : {

          options : {
              browsers : ['last 5 versions'],
              map      : true
          },

          files : {
              expand  : true,
              flatten : true,
              src     : ['assets/css/admin.css', 'assets/css/main.css'],
              dest    : 'assets/css'
          }
      },

      /**
       * Minify CSS after prefixes are added
       */
      cssmin : {

          target : {

              files : [{
                  expand : true,
                  cwd    : 'assets/css',
                  src    : ['admin.css', 'main.css'],
                  dest   : 'assets/css',
                  ext    : '.min.css'
              }]

          }
      },

      /**
       * Process SASS
       */
      sass : {
		options: {
			implementation: sass,
			sourceMap: true
		},

          dist : {

              options : {
                  style     : 'expanded',
                  sourceMap : true,
                  noCache   : true
              },

              files : {
                  'assets/css/admin.css' : 'assets/css/scss/admin.scss',
                  'assets/css/main.css' : 'assets/css/scss/main.scss'
              }
          }
      },

      /**
       * Watch scripts and styles for changes
       */
      watch : {

          options : {
              livereload : false
          },

          scripts : {

              files : [
                  'assets/js/src/admin.js',
                  'assets/js/src/main.js'
              ],

              tasks : ['sass','autoprefixer','cssmin','uglify:backend','uglify:frontend', 'jshint']

          },

          styles : {

              files : [
                  'assets/css/scss/*'
              ],

              tasks : ['sass', 'autoprefixer', 'cssmin']

          }
      },


	} );

	grunt.loadNpmTasks( 'grunt-contrib-jshint' );
	grunt.loadNpmTasks( 'grunt-contrib-uglify' );
	grunt.loadNpmTasks( 'grunt-sass' );
	grunt.loadNpmTasks( 'grunt-contrib-cssmin' );
	grunt.loadNpmTasks( 'grunt-autoprefixer' );
	grunt.loadNpmTasks( 'grunt-contrib-watch' );
	grunt.registerTask( 'build', ['jshint', 'uglify:backend','uglify:frontend', 'sass', 'autoprefixer', 'cssmin'] );

	grunt.util.linefeed = '\n';

};