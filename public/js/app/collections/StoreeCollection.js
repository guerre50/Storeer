// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'App', 'models/StoreeModel', 'localstorage'], function($, _, Backbone, app, StoreeModel) {
    var StoreeCollection, _ref;
    return StoreeCollection = (function(_super) {
      __extends(StoreeCollection, _super);

      function StoreeCollection() {
        _ref = StoreeCollection.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      StoreeCollection.prototype.model = StoreeModel;

      StoreeCollection.prototype.localStorage = new Backbone.LocalStorage('storeer-storees');

      StoreeCollection.prototype.initialize = function() {
        _.bindAll(this);
        this.maxResults = 20;
        this.page = 0;
        this.loading = false;
        app.vent.on('search:query', function(query) {
          return this.search(query);
        }, this);
        return app.vent.on('search:fetch', function() {
          return this.more();
        }, this);
      };

      StoreeCollection.prototype.search = function(query) {
        var self;
        self = this;
        this.page = 0;
        return this.fetchStorees(query, function(storees) {
          return self.reset(storees);
        });
      };

      StoreeCollection.prototype.more = function() {
        var self;
        self = this;
        return this.fetchStorees(this.query, function(storees) {
          return self.add(storees);
        });
      };

      StoreeCollection.prototype.fetchStorees = function(query, callback) {
        if (this.loading || !callback) {
          return true;
        }
        return callback([new StoreeModel()]);
      };

      return StoreeCollection;

    })(Backbone.Collection);
  });

}).call(this);