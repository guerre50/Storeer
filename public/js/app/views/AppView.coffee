# View example
define [
	"jquery"
	"underscore"
	"backbone"
	"views/StoreeView"
	"collections/StoreeCollection"
	"text!templates/boilerplate.html"
], ($, _, Backbone, StoreeView, StoreeCollection, template) ->
	class AppView extends Backbone.View
		el: '#storeer-app'

		initialize: (query) ->
			super
			
			@render()

		# events: 
		render: ->
			super

			compiledTemplate = _.template template, {}
			@.$el.html compiledTemplate

			@

