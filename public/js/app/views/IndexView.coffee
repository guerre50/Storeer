# View example
define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"views/StoreerVisualizer"
	"views/StoreerLibrary"
	"views/StoreerLanding"
	"models/StoreeModel"
	"text!templates/index.html"
], ($, _, Backbone, app, StoreerVisualizer, StoreerLibrary, LandingView, StoreeModel, template) ->
	class IndexView extends Backbone.Marionette.Layout
		template: _.template(template)
		className: 'storeer-content'

		regions:
			landing: '#storeer-landing'
			storee: "#storeer-storee"
			library: "#storeer-library"

		initialize: ->
			return

		onShow: ->
			@landing.show(new LandingView())
			@storee.show(new StoreerVisualizer())
			@library.show(new StoreerLibrary(collection: app.storees))



