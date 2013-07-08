# DropArea View
define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"text!templates/drop.html"
	"models/StoreeModel"
], ($, _, Backbone, app, template, StoreeModel) ->
	class DropAreaView extends Backbone.Marionette.ItemView
		template: _.template(template)
		className: 'storeer-visualizer-drop'

		initialize: ->
			_.bindAll @

			app.vent.on('drag-start:storee', @onDragStart)
			app.vent.on('drag-end:storee', @onDragEnd)
			app.vent.on('requireDrop', @enable)
			app.vent.on('freeDrop', @disable)

		events:
			'drop': 'onDrop'
			'dragenter': 'onDragEnter'
			'dragleave': 'onDragLeave'
			'dragover': 'onDragOver' 

		enable: ->
			@$el.addClass('enabled')

		disable: ->
			@$el.removeClass('enabled')
			
		onDragEnter: (event) ->
			@$el.addClass('drag-over')

		onDragLeave: (event) ->
			@$el.removeClass('drag-over')

		onDragOver: (event) ->
			# This "fixes" a bug in Chrome that prevents
			# drop event from being fired more info: 
			# https://code.google.com/p/chromium/issues/detail?id=168387
			event.preventDefault()

		onDragStart: (event) ->
			@$el.addClass('dragging')

		onDragEnd: (event) ->
			@$el.removeClass('dragging').removeClass('drag-over')

		onDrop: (event) ->
			event = event.originalEvent
			dataTransfer = event.dataTransfer

			storee = dataTransfer.getData('storee')
			if storee then app.vent.trigger('open:storee', new StoreeModel(JSON.parse(storee)))

			url = dataTransfer.getData('text/uri-list')
			if url then app.vent.trigger('load:url', url)

			files = dataTransfer.files
			if files.length > 0 
				images = []

				_.each(files, (img) ->
					if img.type.match('image.*')
						images.push(img)
				)
				app.vent.trigger('load:images', images)

			@$el.removeClass('dragging').removeClass('drag-over')

			return false