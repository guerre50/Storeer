// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'controllers/FlickrController'], function($, _, Backbone, Flickr) {
    var StoreeModel, _ref;
    return StoreeModel = (function(_super) {
      __extends(StoreeModel, _super);

      function StoreeModel() {
        _ref = StoreeModel.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      StoreeModel.prototype.initialize = function(attributes) {
        return _.bindAll(this);
      };

      StoreeModel.prototype.defaults = {
        id: void 0,
        avatar: '/img/avatar.png',
        thumbnail: 'http://farm8.staticflickr.com/7339/9088143629_4134ddf9fe.jpg',
        frames: [
          {
            info: 'Present characters and location'
          }, {
            info: 'Build up the situation'
          }, {
            info: 'Involve characters in the situation'
          }, {
            info: 'Leave it open to different endings'
          }, {
            info: 'Conclude with a surprising end'
          }
        ]
      };

      StoreeModel.prototype.loadExtras = function() {
        if (this.attributes.id) {
          return Flickr.replies(this.attributes.id, 100, 1, this.loadComments, this.loadCommentsFail);
        }
      };

      StoreeModel.prototype.loadComments = function(comments) {
        return this.set("comments", comments);
      };

      StoreeModel.prototype.loadCommentsFail = function(msg) {
        return console.log("message loading fail");
      };

      StoreeModel.prototype.validate = function(attributes) {
        return true;
      };

      return StoreeModel;

    })(Backbone.Model);
  });

}).call(this);
