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
		dragTab: '#drag-tab'
		tabs: '#explorer-tabs'

		regions:
			dropPanel: "#drop-panel"
			storee: "#storeer-storee"
			library: "#storeer-library"

		events:
			'drop': 'onDrop'
			'dragenter  .storeer-visualizer-drop': 'onDragEnter'
			'dragleave .storeer-visualizer-drop': 'onDragLeave'
			'dragover .storeer-visualizer-drop': 'onDragOver'
			'mousedown .explorer-tabs' : 'onMouseDown'
			'click .explorer-tab.library' : 'showLibrary'
			'click .explorer-tab.storee' : 'showStoree'
			'mouseenter .explorer-tab.library' : 'showLibrary'
			'mouseenter .explorer-tab.storee' : 'showStoree'
			'mouseup .explorer-tab.library' : 'showLibrary'
			'mouseup .explorer-tab.storee' : 'showStoree'

		initialize: ->
			_.bindAll @

			app.vent.on('drag-start:storee', @onDragStart)
			app.vent.on('drag-end:storee', @onDragEnd)
			app.vent.on('close:storee', @closeStoree)
			app.vent.on('open:storee', @openStoree)

			@$dropPanel = $(@regions.dropPanel)
			@$tabs = $(@tabs)
			@$body = $('body')

		closeStoree: ->
			@storee.show(new HomeView())

		onShow: ->
			@storee.show(new HomeView())
			@library.show(new StoreerLibrary(collection: app.storees))

			@$dropPanel = $(@regions.dropPanel)
			@$dragTab = $(@dragTab)

		onDrop: (event) ->
			storee = event.originalEvent.dataTransfer.getData("storee")

			if storee then @openStoree(new StoreeModel(JSON.parse(storee)))
				

		openStoree: (storee) ->
			app.router.navigate('storees/' + storee.id)
			@storee.show(new StoreerVisualizer({model: storee}))

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
			

		onMouseDown: (event) ->
			@dragging = true
			$(window).on('mousemove', @onMouseMove)
			$(window).on('mouseup', @onMouseUp)

		onMouseUp: (event) ->
			@dragging = false
			$(window).off('mousemove', @onMouseMove)
			$(window).off('mouseup', @onMouseUp)

		onMouseMove: (event) ->
			if @dragging
				left = event.clientX / @$body.width()*100
				# We clamp mouse move to tab space
				min = 100 - @tabSize()*1.5
				max = 100 - @tabSize()*0.5
				if left < min
					left = min
				else if  left > max
					left = max

				@slideTab(left + @tabSize()/2)

		showStoree: ->
			if not @dragging then return
			@slideTab(100 - @tabSize())

		showLibrary: ->
			if not @dragging then return
			@slideTab(100)

		tabSize: ->
			(@$dragTab.width()/@$body.width()) * 100

		slideTab: (left) ->
			tabSize = @tabSize()
			
			@$dragTab.css('right', ((100-(left))/100*@$body.width()) + "px")

			# We set left for the tab content
			if left > 100 - tabSize then left = 0 else left = 100

			@library.$el.css('left', left + "%")
			@storee.$el.parent().css('left', - (100-left) + "%")




