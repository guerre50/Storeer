// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'App', 'models/StoreeModel', 'controllers/FlickrController', 'localstorage'], function($, _, Backbone, app, StoreeModel, flickr) {
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
        this.maxResults = 10;
        this.page = 1;
        app.vent.on('search:more', this.more);
        return app.vent.on('search:term', this.search);
      };

      StoreeCollection.prototype.search = function(query) {
        this.page = 0;
        this.query = query;
        return this.fetchStorees(query, this.fetchReset);
      };

      StoreeCollection.prototype.more = function() {
        this.page++;
        return this.fetchStorees(this.query, this.fetchMore);
      };

      StoreeCollection.prototype.fetchReset = function(storees) {
        this.reset(storees);
        return this.loading = false;
      };

      StoreeCollection.prototype.fetchMore = function(storees) {
        this.add(storees);
        return this.loading = false;
      };

      StoreeCollection.prototype.fetchStorees = function(query, callback) {
        if (this.loading || !callback) {
          return;
        }
        this.loading = true;
        return flickr.topics(this.maxResults, this.page, callback, this.fetchFail);
      };

      StoreeCollection.prototype.fetchFail = function(msg) {
        return console.log("fail");
      };

      return StoreeCollection;

    })(Backbone.Collection);
  });

}).call(this);
