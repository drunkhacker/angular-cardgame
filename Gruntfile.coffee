'use strict'

livereload_port = 35729
lrSnippet = require('connect-livereload') port: livereload_port
accessAllow = (req, res, next) ->
  res.setHeader 'Access-Control-Allow-Origin', '*'
  res.setHeader 'Access-Control-Allow-Methods', '*'
  next()

mountFolder = (connect, dir) ->
  connect.static(require('path').resolve(dir))

module.exports = (grunt) ->
  # show elapsed time at the end
  require('time-grunt') grunt
  # load all grunt tasks
  require('load-grunt-tasks') grunt

  grunt.initConfig
    watch:
      options:
        livereload: true
      coffee:
        files: ['app/scripts/{,*/}*.coffee']
        tasks: ['coffee']
        options:
          livereload: false
      less:
        files: ['app/styles/{,*/}*.less']
        tasks: 'less'
        options:
          livereload: false
      scripts:
        files: '{.tmp, app}/scripts/{,*/}*.js'
      imgs:
        files: 'app/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
      styles:
        files: ['{.tmp, app}/styles/{,*/}*.css']
      views:
        files: ['{app, .tmp}/index.html']
        options:
          livereload: true
      jade:
        files:
          ['app/views/{,*/}*.jade', 'app/index.jade']
        tasks: 'jade'
        options:
          livereload: false
    connect:
      options:
        port: 9000
        hostname: '*'
      livereload:
        options:
          middleware: (connect) ->
            [ lrSnippet, accessAllow, mountFolder(connect, '.tmp'), mountFolder(connect, 'app')]
    concat:
      server:
        files: ".tmp/scripts/services.js": ['app/scripts/services/services.js', '.tmp/scripts/services/*.js']
    coffee:
      server:
        files: [
            '.tmp/scripts/app.js' : 'app/scripts/app.coffee'
            '.tmp/scripts/controllers.js' : 'app/scripts/controllers/*.coffee'
          ,
            expand: true
            cwd: 'app/scripts/services'
            src: '{,*/}*.coffee'
            dest: '.tmp/scripts/services'
            ext: '.js'
        ]
    clean:
      server: '.tmp'
      dist: 'dist'
    less:
      server:
        files: [
          expand: true
          cwd: 'app/styles'
          src: '{,*/}*.less'
          dest: '.tmp/styles'
          ext: '.css'
        ]
    jade:
      compile:
        files: [
            expand: true
            cwd: 'app/views/'
            src: '{,*/}*.jade'
            dest: '.tmp/views/'
            ext: '.html'
          ,
            '.tmp/index.html' : 'app/index.jade'
        ]
    concurrent:
      server: ['coffee', 'less', 'jade']
      dist: ['coffee', 'less', 'jade']
    copy:
      dist:
        # copy .tmp files to dest directory because 
        # coffee, less, jade tasks generate compiled 
        # files to .tmp 
        files: [
            expand: true
            cwd: '.tmp'
            src: '**'
            dest: 'dist'
          ,
            #dump serve-ready (.css, .html, .js) to dist
            expand: true
            cwd: 'app'
            src: '{,**/}*.{html,css,js}'
            dest: 'dist'
          ,
            #dump images to dist as it is
            expand: true
            cwd: 'app'
            src: 'images/**'
            dest: 'dist'
          ,
            #dump bower components as it is
            expand: true
            cwd: 'app'
            src: 'bower_components/**'
            dest : 'dist'
        ]

  grunt.registerTask 'server', [ 'clean:server', 'concurrent:server', 'concat', 'connect:livereload', 'watch' ]
  grunt.registerTask 'dist', [ 'clean:dist', 'concurrent:dist', 'concat', 'copy:dist' ]
