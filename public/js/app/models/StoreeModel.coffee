define [
	'jquery'
	'underscore'
	'backbone'
	'controllers/FlickrController'
], ($, _, Backbone, Flickr) ->
	class StoreeModel extends Backbone.Model
		initialize: (attributes) ->
			_.bindAll @

			if attributes.author and not attributes.authorModel
				Flickr.user(attributes.author, @loadAuthor, @loadAuthorFail)

		defaults: 
			id: 2
			thumbnail: 'http://farm8.staticflickr.com/7339/9088143629_4134ddf9fe.jpg'
			frames: [
				{src: 'http://farm8.staticflickr.com/7339/9088143629_4134ddf9fe.jpg'}
				{src: 'http://farm8.staticflickr.com/7434/9090364692_7b5ceb9fe7.jpg'}
				{src: 'http://farm4.staticflickr.com/3781/9088142449_13561296dd.jpg'}
				{src: 'http://farm3.staticflickr.com/2818/9090363626_841887123f.jpg'}
				{src: 'http://farm8.staticflickr.com/7354/9090365846_0601a01414.jpg'}
			]

		loadExtras: ->
			Flickr.replies(@attributes.id ,100, 1, @loadComments, @loadCommentsFail)

		loadAuthor: (author) ->
			@attributes.authorModel = author

		loadAuthorFail: (msg) ->
			console.log "load author fail"

		loadComments: (comments) ->
			@set("comments", comments)

		loadCommentsFail: (msg) ->
			console.log "message loading fail"


		validate: (attributes) ->
			return true;