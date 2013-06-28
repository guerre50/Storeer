# Page Base
define [
	"jquery"
	"underscore"
	"backbone"
	"text!templates/base.html"
], ($, _, Backbone, template) ->
	class RouteView extends Backbone.View
		el: $("body")

		initialize: (query) ->
			return

		# events: 
		render: ->
			console.log "render RouteView"
			compiledTemplate = _.template template, {}
			@.$el.html compiledTemplate

			@

