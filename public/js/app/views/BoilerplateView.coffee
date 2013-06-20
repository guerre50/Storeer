# View example
define [
	"jquery"
	"underscore"
	"models/BoilerplateModel"
	"text!templates/boilerplate.html"
], ($, _, Model, template) ->
	class BoilerplateView extends Backbone.View
		el: $("#boilerplate")

		initialize: ->
			@.render()

		# events: 
		render: ->
			compiledTemplate = _.template template, {}
			@.$el.html compiledTemplate

			@

