# View example
define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"views/StoreerVisualizer"
	"views/StoreerLibrary"
	"views/LandingView"
	"views/HomeView"
	"models/StoreeModel"
	"text!templates/explorer.html"
], ($, _, Backbone, app, StoreerVisualizer, StoreerLibrary, LandingView, HomeView, StoreeModel, template) ->
	class ExplorerView extends Backbone.Marionette.Layout
		template: _.template(template)
		className: 'storeer-content'

		regions:
			dropPanel: "#drop-panel"
			storee: "#storeer-storee"
			library: "#storeer-library"

		events:
			'drop': 'onDrop'
			'dragenter  .storeer-visualizer-drop': 'onDragEnter'
			'dragleave .storeer-visualizer-drop': 'onDragLeave'
			'dragover .storeer-visualizer-drop': 'onDragOver'

		initialize: ->
			_.bindAll @

			app.vent.on('drag-start:storee', @onDragStart)
			app.vent.on('drag-end:storee', @onDragEnd)
			app.vent.on('close:visualizer', @closeVisualizer)

			@$dropPanel = $(@regions.dropPanel)

		closeVisualizer: ->
			@storee.show(new HomeView())

		onShow: ->
			@storee.show(new HomeView())
			@library.show(new StoreerLibrary(collection: app.storees))

			@$dropPanel = $(@regions.dropPanel)

		onDrop: (event) ->
			storee = event.originalEvent.dataTransfer.getData("storee")

			if storee
				@storee.show(new StoreerVisualizer({model: new StoreeModel(storee)}))

		onDragEnter: (event) ->
			@$dropPanel.addClass('drag-over')


		onDragLeave: (event) ->
			@$dropPanel.removeClass('drag-over')

		onDragOver: (event) ->
			# This "fixes" a bug in Chrome that prevents
			# drop event from being fired more info: 
			# https://code.google.com/p/chromium/issues/detail?id=168387
			event.preventDefault()

		onDragStart: (event) ->
			@$dropPanel.addClass('dragging')

		onDragEnd: (event) ->
			@$dropPanel.removeClass('dragging').removeClass('drag-over')



