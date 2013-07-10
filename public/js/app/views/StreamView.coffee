# Stream View
define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"text!templates/stream.html"
	"views/StoreeStripView"
], ($, _, Backbone, app, template, StoreeStripView) ->
	class StreamView extends Backbone.Marionette.CompositeView
		itemView: StoreeStripView,
		template: _.template(template)
		className: 'storeer-stream-content'

		topItem: undefined
		bottomItem: undefined
		scrollTop : 0
		scrollTopDestiny: 0
		# margin that we want to add to the scroll view
		margin: 2000
		# margin at which we want to load more images
		loadMargin: 2000

		ui:
			stream: '#storeer-stream'

		events:
			'mousewheel': 'onMouseWheel'

		initialize: ->
			_.bindAll @

		remove: ->
			clearTimeout(@scrollTimeout)
			@ui.stream.off('scroll', @delayedOnScroll)
			Backbone.View.prototype.remove.apply(@)

		onShow: ->
			@ui.stream.on('scroll', @delayedOnScroll)

		appendHtml: (collectionView, itemView, itemIndex) ->
			# We see if there is already a "prjevious render" of the item
			stream = collectionView.$(".storeer-stream")
			item = $(stream.children()[itemIndex])

			# If that is the case we assign the already existing item to
			# the new view
			if item and parseInt(item.attr('data-index')) == itemIndex
				itemView.setElement(item).bindUIElements()
			else
				# We append it to the stream View
				stream.append(itemView.el)

			# we mark the element with data bout the view
			$el = $(itemView.el)
					.attr('data-cid', itemView.cid)
					.attr('data-index', itemIndex)
			
			if not @topItem
				@topItem = $el
				@bottomItem = $el

			if @visible($el)
				itemView.visible(true)

		updateVisibility: (direction) ->
			if direction < 0 
				[@bottomItem, @topItem] = @move('prev')
			else if direction > 0
				[@topItem, @bottomItem] = @move('next')
			#console.log "top", @topItem.attr('data-index')
			#console.log "bottom", @bottomItem.attr('data-index')
			@


		move: (direction) ->
			# We first move in the direction of the movement until we
			# find a visible item. Then we keep moving from there until
			# we find a non visible item
			extremeA = @moveWhileVisibilityIs(@topItem, direction, false)
			extremeB = @moveWhileVisibilityIs(extremeA, direction, true)

			[extremeA, extremeB]


		# Iterates in the specified direction, using item as the start point
		# and keeps moving while its visibility it's like the specified
		moveWhileVisibilityIs: (item, direction, isVisible) ->
			# TO-DO this could be improved by using binary search
			prevItem = item

			while @visible(item) == isVisible
				prevItem = item
				# We iterate to the "next" element before
				# adding or removing because that can change
				# the DOM configuration
				item = item[direction]()

				if not isVisible
					@removeItem(prevItem)
				else
					@addItem(prevItem)

			# If we have reached the last or first item
			# we return the previous visited 
			if item.length == 0
				item = prevItem

			item

		visible: (item) ->
			if not item or item.length == 0 then return undefined

			scroll = @scrollData()
			itemTop = item.position().top + scroll.top

			not (itemTop > scroll.bottom + 800 or itemTop + item.height() < scroll.top - 800)

		scrollData: ->
			scroll = @ui.stream[0]
			{
				top : scroll.scrollTop
				height : scroll.scrollHeight
				bottom : scroll.scrollTop + scroll.clientHeight
			}

		# removes a ItemView but keeps its related DOM 
		removeItem: (item) ->
			itemView = @children._views[item.attr('data-cid')]
			
			if itemView
				# Uncomment if you want to call itemView to unload whatever is needed
				# itemView.visible(false)
				copy = item[0].outerHTML
				$(copy).insertAfter(item)
				@removeChildView(itemView)

		# adds an ItemView making it visible if it was already existing or it creates a
		# new one otherwise
		addItem: (item) ->
			itemView = @children._views[item.attr('data-cid')]

			if itemView
				itemView.visible(true)
			else
				@addChildView(@collection.at(item.attr('data-index')))

		onMouseWheel: (event) ->
			event.preventDefault()
			scroll = @scrollData()
			deltaY = event.originalEvent.wheelDeltaY

			sign = @sign(deltaY)

			# scroll movement is clamped
			newDestiny = @scrollTopDestiny + Math.max(Math.abs(deltaY), 80)*sign
			newDestiny = Math.max(Math.min(newDestiny, scroll.height), 0)

			if @scrollTopDestiny != newDestiny
				@scrollTopDestiny = newDestiny

				# we stop the animations and animate the new one
				@ui.stream.css('padding-top', 0)
				@ui.stream
					.clearQueue()
					.stop()
					.animate({scrollTop: @scrollTopDestiny}, 400, 'easeOutQuad')

				if @scrollTopDestiny == 0
					@ui.stream
						.animate({'padding-top': 40}, 100)
						.animate({'padding-top': 0}, 150)


		delayedOnScroll: (event) ->
			scrollTop = event.target.scrollTop

			if not @visible(@topItem) or not @visible(@bottomItem)
				@onScroll(event)

			clearTimeout(@scrollTimeout)
			@scrollTimeout = setTimeout(@onScroll, 200)

		onScroll: (event) ->
			scroll = @scrollData()

			@updateVisibility(scroll.top - @scrollTop)
			@scrollTop = scroll.top

			if scroll.height - @loadMargin < scroll.bottom
				app.vent.trigger('search:more')

		sign: (value) ->
			if value > 0 
				return -1
			else if value < 0
				return 1

			return 0
				
				

