# View example
define [
	"jquery"
	"underscore"
	"backbone"
	"text!templates/landing.html"
], ($, _, Backbone, template) ->
	class LandingView extends Backbone.Marionette.ItemView
		template: _template(template)
