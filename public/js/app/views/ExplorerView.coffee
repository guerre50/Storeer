# Explorer View
define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"views/StoreerVisualizer"
	"views/StoreerLibrary"
	"views/LandingView"
	"views/HomeView"
	"views/DropAreaView"
	"views/StreamView"
	"models/StoreeModel"
	"text!templates/explorer.html"
], ($, _, Backbone, app, StoreerVisualizer, StoreerLibrary, LandingView, HomeView, DropAreaView, StreamView, StoreeModel, template) ->
	class ExplorerView extends Backbone.Marionette.Layout
		template: _.template(template)
		className: 'storeer-content'
		tabs: '#explorer-tabs'
		tabsMobile: '#explorer-tabs-mobile'

		regions:
			dropArea: "#drop-panel"
			storee: "#storeer-storee"
			library: "#storeer-library"
			overlay: "#storeer-overlay"

		events:
			'click .explorer-tab' : 'toggleSidePanel'

		initialize: ->
			_.bindAll @

			app.vent.on('close:storee', @closeStoree)
			app.vent.on('open:storee', @openStoree)
			app.vent.on('create:storee', @createStoree)

		remove: ->
			app.vent.off('close:storee', @closeStoree)
			app.vent.off('open:storee', @openStoree)
			app.vent.off('create:storee', @createStoree)

		onShow: ->
			@storee.show(new StreamView(collection: app.storees))
			@dropArea.show(new DropAreaView())
			@library.show(new StoreerLibrary(collection: app.storees))

			@$dropArea = $(@regions.dropArea)
			@$dragTab = $(@dragTab)
			@$tabs = $(@tabs)
			@$tabsMobile = $(@tabsMobile)
			@$body = $('body')

			# We enable side panel and tabs
			@library.$el.parent().toggleClass('enabled', true)
			@$tabsMobile.parent().toggleClass('enabled', true)

		closeStoree: ->
			if @overlay.$el.hasClass('enabled')
				@overlay.close()
				@overlay.$el.toggleClass('enabled', false)
			else
				@storee.show(new StreamView(collection: app.storees))

		openStoree: (storee) ->
			app.router.navigate('storees/' + storee.id)

			if @storee
				@overlay.show(new StoreerVisualizer({model: storee}))
				@overlay.$el.toggleClass('enabled', true)
			else
				@storee.show(new StoreerVisualizer({model: storee}))

			#@toggleSidePanel(false)

		createStoree: ->
			@storee.show(new StoreerVisualizer({model: new StoreeModel()}))
			@removeSidePanel()	

		toggleSidePanel: (value) ->
			if value != undefined and value == @isSidePanelOpen() then return

			sidePanel = @library.$el.parent()
			sidePanel.toggleClass('expanded')
			sidePanel.css('left', if sidePanel.hasClass('expanded') then '0%' else '100%')

			$(@$tabs.children()[1]).toggleClass('active')
			$(@$tabsMobile.children()[1]).toggleClass('active')

		isSidePanelOpen: ->
			return @library.$el.parent().hasClass('expanded')

		removeSidePanel: ->
			@library.close()
			@library.$el.parent().toggleClass('enabled', false)
			@$tabsMobile.parent().toggleClass('enabled', false)
			




