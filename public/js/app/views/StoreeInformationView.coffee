# View example
define [
	"jquery"
	"underscore"
	"backbone"
	"text!templates/boilerplate.html"
], ($, _, Backbone, template) ->
	class BoilerplateView extends RouteView
		el: $("#boilerplate")

		path: 'boilerplate'

		route: ''

		initialize: (query) ->
			super
			console.log query
			@.render()

		# events: 
		render: ->
			compiledTemplate = _.template template, {}
			@.$el.html compiledTemplate

			@

