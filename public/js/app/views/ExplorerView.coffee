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
		dragTab: '#drag-tab'
		tabs: '#explorer-tabs'
		tabsMobile: '#explorer-tabs-mobile'

		regions:
			dropArea: "#drop-panel"
			storee: "#storeer-storee"
			library: "#storeer-library"

		events:
			'mousedown .explorer-tabs' : 'onMouseDown'
			'click .explorer-tab' : 'selectTab'
			'mouseenter .explorer-tab' : 'onMouseEnter'

		initialize: ->
			_.bindAll @

			app.vent.on('close:storee', @closeStoree)
			app.vent.on('open:storee', @openStoree)
			app.vent.on('create:storee', @createStoree)

		closeStoree: ->
			@storee.show(new HomeView())

		onShow: ->
			@storee.show(new StreamView(collection: app.storees))
			#@storee.show(new HomeView())
			@dropArea.show(new DropAreaView())
			@library.show(new StoreerLibrary(collection: app.storees))

			@$dropArea = $(@regions.dropArea)
			@$dragTab = $(@dragTab)
			@$tabs = $(@tabs)
			@$tabsMobile = $(@tabsMobile)
			@$body = $('body')

		openStoree: (storee) ->
			app.router.navigate('storees/' + storee.id)
			@storee.show(new StoreerVisualizer({model: storee}))

			# TO-DO make this less dependent on DOM
			@show($(@$tabs.children()[0]))

		toggleMenu: (menu) ->
			$(@library.$el.parent()).toggleClass('expanded')

		createStoree: ->
			@storee.show(new StoreerVisualizer({model: new StoreeModel()}))
			@library.close()

			# TO-DO make this less dependent on DOM
			@show($(@$tabs.children()[0]))

		onMouseDown: (event) ->
			@dragging = true
			$(window).on('mousemove', @onMouseMove)
			$(window).on('mouseup', @onMouseUp)

		onMouseUp: (event) ->
			@dragging = false
			$(window).off('mousemove', @onMouseMove)
			$(window).off('mouseup', @onMouseUp)

		closeMenu: ->
			@library.$el.addClass('closed')
			@library.close()

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

		selectTab: (event) ->
			target = $(event.currentTarget).data('target')
			if target == 1
				@toggleMenu()
			@show($(event.currentTarget))

		onMouseEnter: (event) ->
			if @dragging then @show($(event.currentTarget))

		show: (tab) ->
			@$tabs.find('.active').toggleClass('active', false)
			@$tabsMobile.find('.active').toggleClass('active', false)

			tabIndex = tab.data('target')
			$(@$tabs.children()[tabIndex]).toggleClass('active', true)
			$(@$tabsMobile.children()[tabIndex]).toggleClass('active', true)

			tabContents = @tabContents()
			left = -100*tab.data('target')
			first = 0
			_.each(tabContents, (tabContent) ->
				if first > 0
					tabContent.css('left', left + '%')
				else
					first = 1
				left += 100
			)

			@slideTab((tab.position().left) / @$body.width()*100 + @tabSize())

		tabSize: ->
			(@$dragTab.width()/@$body.width()) * 100

		tabContents: ->
			return [@storee.$el.parent(), @library.$el.parent()]

		slideTab: (left) ->
			# We move the dragging tab selector
			tabSize = @tabSize()
			@$dragTab.css('right', ((100-left)/100*@$body.width()) + "px")
			




