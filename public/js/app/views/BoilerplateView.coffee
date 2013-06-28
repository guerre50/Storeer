# View example
define [
	"jquery"
	"underscore"
	"views/RouteView"
	"models/BoilerplateModel"
	"text!templates/boilerplate.html"
], ($, _, RouteView, Model, template) ->
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

