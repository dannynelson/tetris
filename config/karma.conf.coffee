module.exports = (config) ->
  config.set
    basePath : '..'

    files : ['client/**.coffee']

    frameworks: ['jasmine', 'browserify']

    browsers : ['PhantomJS']

    browserify:
      extensions: ['.coffee']
      transform: ['coffeeify']
      watch: true   # Watches dependencies only (Karma watches the tests)
      debug: true   # Adds source maps to bundle
      noParse: ['jquery'] # Don't parse some modules

    preprocessors:
      '**/client/**/!(*spec|*unit|*e2e|*test).js': 'coverage'
      '**/*.coffee': ['coffee']
      '**/*.coffee': ['browserify']

    coverageReporter:
      dir: 'coverage'
