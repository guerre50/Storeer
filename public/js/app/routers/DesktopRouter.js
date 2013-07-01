// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'marionette', 'App', 'views/LandingView', 'views/ExplorerView'], function($, _, Backbone, Marionette, app, LandingView, ExplorerView) {
    var DesktopRouter, _ref;
    return DesktopRouter = (function(_super) {
      __extends(DesktopRouter, _super);

      function DesktopRouter() {
        _ref = DesktopRouter.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      DesktopRouter.prototype.initialize = function() {
        return Backbone.history.start();
      };

      DesktopRouter.prototype.routes = {
        '': 'landing',
        'storees': 'storees',
        'storees/:id': 'storees',
        '*actions': 'landing'
      };

      DesktopRouter.prototype.storees = function(id) {
        app.content.show(new ExplorerView());
        return app.vent.trigger('search:term', '');
      };

      DesktopRouter.prototype.landing = function() {
        return app.content.show(new LandingView());
      };

      return DesktopRouter;

    })(Backbone.Marionette.AppRouter);
  });

}).call(this);
