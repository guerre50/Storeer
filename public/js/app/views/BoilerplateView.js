// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["jquery", "underscore", "views/RouteView", "models/BoilerplateModel", "text!templates/boilerplate.html"], function($, _, RouteView, Model, template) {
    var BoilerplateView, _ref;
    return BoilerplateView = (function(_super) {
      __extends(BoilerplateView, _super);

      function BoilerplateView() {
        _ref = BoilerplateView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      BoilerplateView.prototype.el = $("#boilerplate");

      BoilerplateView.prototype.path = 'boilerplate';

      BoilerplateView.prototype.route = '';

      BoilerplateView.prototype.initialize = function(query) {
        BoilerplateView.__super__.initialize.apply(this, arguments);
        console.log(query);
        return this.render();
      };

      BoilerplateView.prototype.render = function() {
        var compiledTemplate;
        compiledTemplate = _.template(template, {});
        this.$el.html(compiledTemplate);
        return this;
      };

      return BoilerplateView;

    })(RouteView);
  });

}).call(this);
