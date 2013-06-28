// Generated by CoffeeScript 1.6.3
(function() {
  require.config({
    baseUrl: './js/app',
    paths: {
      'jquery': '../libs/jquery',
      'jqueryui': '../libs/jqueryui',
      'jquerymobile': '../libs/jquery.mobile',
      'underscore': '../libs/lodash',
      'backbone': '../libs/backbone',
      'backbone.validateAll': '../libs/plugins/Backbone.validateAll',
      'bootstrap': '../libs/plugins/bootstrap',
      'text': '../libs/plugins/text',
      'jasminejquery': '../libs/plugins/jasmine-jquery',
      'normalize': '../libs/plugins/normalize',
      'css': '../libs/plugins/require-css',
      'less': '../libs/plugins/require-less',
      'lessc': '../libs/plugins/lessc',
      'localstorage': '../libs/plugins/Backbone.localStorage',
      'wreqr': '../libs/plugins/backbone.wreqr',
      'babysitter': '../libs/plugins/backbone.babysitter',
      'json2': '../libs/plugins/json2',
      'marionette': '../libs/plugins/backbone.marionette',
      'prefixfree': '../libs/prefixfree.min'
    },
    config: {
      'css': {
        'baseUrl': './css'
      },
      'less': {
        'baseUrl': './css'
      }
    },
    shim: {
      "jquerymobile": ["jquery"],
      "bootstrap": ["jquery"],
      "jqueryui": ["jquery"],
      "backbone": {
        "deps": ["underscore", "jquery"],
        "exports": "Backbone"
      },
      "backbone.validateAll": ["backbone"],
      "jasminejquery": ["jquery"],
      "marionette": {
        "deps": ["jquery", "underscore", "backbone", "wreqr", "babysitter", "json2"],
        "exports": "Marionette"
      },
      "wreqr": ["backbone"],
      "babysitter": ["backbone"],
      "less": ["prefixfree"],
      "css": ["prefixfree"]
    }
  });

}).call(this);
