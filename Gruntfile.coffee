module.exports = (grunt) ->
  require('matchdep').filterAll('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.initConfig
    clean:
      compiled: ['public']
    
    coffeeify:
      options:
        debug: true
      compile:
        files:
          'public/bundle.js': ['client/index.coffee', 'client/index.js']

    connect:
      server:
        options:
          port: 8000
          open: true
          base: 'public'
          keepalive: true

    copy:
      main:
        files: [
          expand: true, cwd: 'client', src: ['assets/**/*.!(js|coffee|html|styl|css)'], dest: 'public'
        ]

    htmlbuild:
      templates:
        src: 'client/index.html'
        dest: 'public/index.html'
        options:
          sections:
            templates: 'client/**/!(index).html'

    karma:
      options:
        configFile: 'config/karma.conf.coffee',
      browser:
        autoWatch: true,
        singleRun: false,
        browsers: ['Chrome', 'Firefox']
      continuous:
        singleRun: true,
      coverage:
        reporters: ['coverage'],
      watch:
        autoWatch: true,
        singleRun: false
      debug:
        autoWatch: true,
        singleRun: false,
        browsers: ['Chrome']

    stylus:
      compile:
        files:
          'public/bundle.css': 'client/index.styl'

    watch:
      build:
        options: livereload: true
        files: ['{client,lib,server}/**', 'Gruntfile.js']
        tasks: ['build']

  grunt.registerTask 'build', [
    'clean'
    'coffeeify'
    'htmlbuild'
    'stylus'
    'copy'
  ]
