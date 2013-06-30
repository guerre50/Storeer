# View example
define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"views/StoreerVisualizer"
	"views/StoreerLibrary"
	"views/LandingView"
	"models/StoreeModel"
	"text!templates/explorer.html"
], ($, _, Backbone, app, StoreerVisualizer, StoreerLibrary, LandingView, StoreeModel, template) ->
	class ExplorerView extends Backbone.Marionette.Layout
		template: _.template(template)
		className: 'storeer-content'

		regions:
			storee: "#storeer-storee"
			library: "#storeer-library"

		initialize: ->
			return

		onShow: ->
			@storee.show(new StoreerVisualizer())
			@library.show(new StoreerLibrary(collection: app.storees))



