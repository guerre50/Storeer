define [
	'jquery'
	'underscore'
	'backbone'
	'controllers/FlickrController'
], ($, _, Backbone, Flickr) ->
	class StoreeModel extends Backbone.Model
		initialize: (attributes) ->
			_.bindAll @

		defaults: 
			id: undefined
			avatar: '/img/avatar.png'
			thumbnail: 'http://farm8.staticflickr.com/7339/9088143629_4134ddf9fe.jpg'
			frames: [
				{info: 'Present characters and location'}
				{info: 'Build up the situation'}
				{info: 'Involve characters in the situation'}
				{info: 'Leave it open to different endings'}
				{info: 'Conclude with a surprising end'}
			]

		loadExtras: ->
			if @attributes.id
				Flickr.replies(@attributes.id ,100, 1, @loadComments, @loadCommentsFail)

		loadComments: (comments) ->
			@set("comments", comments)

		loadCommentsFail: (msg) ->
			console.log "message loading fail"

		validate: (attributes) ->
			return true