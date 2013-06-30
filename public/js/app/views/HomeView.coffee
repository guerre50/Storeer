define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"text!templates/home.html"
], ($, _, Backbone, app, template) ->
	class HomeView extends Backbone.Marionette.ItemView
		template: _.template(template)