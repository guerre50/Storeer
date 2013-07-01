define [
	'jquery'
	'underscore'
	'backbone'
], ($, _, Backbone) ->
	class StoreeModel extends Backbone.Model

			
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


		validate: (attributes) ->
			return true;