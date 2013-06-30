// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["jquery", "underscore", "backbone", "marionette", "App", "text!templates/landing.html"], function($, _, Backbone, Marionette, app, template) {
    var LandingView, _ref;
    return LandingView = (function(_super) {
      __extends(LandingView, _super);

      function LandingView() {
        _ref = LandingView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      LandingView.prototype.className = 'landing-container';

      LandingView.prototype.template = _.template(template);

      LandingView.prototype.landingStoree = '#landing-storee';

      LandingView.prototype.landingTexts = '#landing-text';

      LandingView.prototype.initialize = function() {
        return _.bindAll(this);
      };

      LandingView.prototype.onShow = function() {
        this.$landingStoree = $(this.landingStoree);
        return this.$landingTexts = $(this.landingTexts);
      };

      LandingView.prototype.events = {
        'click .landing-storee': 'onLandingStoreeClick',
        'click .landing-button': 'onLandingButtonClick'
      };

      LandingView.prototype.onLandingStoreeClick = function(event) {
        var newActive, oldActive;
        oldActive = this.$landingStoree.find('.active');
        oldActive.toggleClass('active');
        $(oldActive.data('text')).toggleClass('active');
        newActive = $(event.currentTarget);
        newActive.toggleClass('active');
        return $(newActive.data('text')).toggleClass('active');
      };

      LandingView.prototype.onLandingButtonClick = function(event) {
        return app.router.navigate('explorer', {
          trigger: true
        });
      };

      return LandingView;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
