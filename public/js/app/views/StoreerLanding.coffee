# View example
define [
	"jquery"
	"underscore"
	"backbone"
	"marionette"
	"text!templates/landing.html"
], ($, _, Backbone, Marionette, template) ->
	class LandingView extends Backbone.Marionette.ItemView
		className: 'landing-container' 
		template: _.template(template)

