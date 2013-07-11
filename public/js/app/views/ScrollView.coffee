# Stream View
define [
	"jquery"
	"underscore"
	"backbone"
	"marionette"
], ($, _, Backbone, Marionette) ->
	class ScrollView extends Backbone.Marionette.CompositeView
		topItem: undefined
		bottomItem: undefined
		scrollTop : 0
		scrollTopDestiny: 0
		_viewsQueue: []

		# margin that we want to add to the scroll view
		visibleMargin: 2000
		# margin at which we want to load more images
		loadMargin: 2000

		events:
			'mousewheel': '_onMouseWheel'

		ui:
			scroll: '.scroll'

		initialize: ->
			_.bindAll @

		remove: ->
			@_viewsQueue = null
			clearTimeout(@appendTimeout)
			clearTimeout(@_scrollTimeout)
			# remove is called after unsetting the ui bindings so we have to find
			# the one related with scroll
			@$el.find(@ui.scroll).off('scroll', @_delayedOnScroll)

			Backbone.View.prototype.remove.apply(@)

		onShow: ->
			@ui.scroll.on('scroll', @_delayedOnScroll)

		appendHtml: (collectionView, itemView, itemIndex) ->
			if itemIndex < 8
				@_appendHtml(collectionView, itemView, itemIndex)
			else
				@_viewsQueue.push([collectionView, itemView, itemIndex])
				clearTimeout(@appendTimeout)
				@appendTimeout = setTimeout(@_checkAppend, 500)

		_checkAppend: ->
			if @_viewsQueue.length > 0
				front = @_viewsQueue.shift()
				@_appendHtml(front[0], front[1], front[2])
				@appendTimeout = setTimeout(@_checkAppend, 500)

		pending: ->
			return @_viewsQueue.length > 0
			
		_appendHtml: (collectionView, itemView, itemIndex) ->
			# We see if there is already a "previous render" of the item
			scroll = @ui.scroll
			item = $(scroll.children()[itemIndex])

			# If that is the case we assign the already existing item to
			# the new view
			if item and parseInt(item.attr('data-index')) == itemIndex
				itemView.setElement(item).bindUIElements()
			else
				# We append it to the stream View
				scroll.append(itemView.el)
				item = scroll.children().last()

			$el = $(scroll.children()[itemIndex])
				.attr('data-cid', itemView.cid)
				.attr('data-index', itemIndex)

			# Management of top and BottomItem
			if not @topItem
				@topItem = $el
				@bottomItem = $el
			else
				# We have to take care of updating topItem and bottom
				# if those are replaced by a new itemView
				if @_equals(@topItem, $el) 
					@topItem = $el

				if @_equals(@bottomItem, $el) 
					@bottomItem = $el

			if @_visible($el)
				itemView.trigger('visible', true)

		_equals: (itemA, itemB) ->
			parseInt(itemA.attr('data-index')) == parseInt(itemB.attr('data-index')) and itemA.attr('data-cid') != itemB.attr('data-cid')

		_updateVisibility: (direction) ->
			if direction < 0 
				[@bottomItem, @topItem] = @_move('prev')
			else if direction > 0
				[@topItem, @bottomItem] = @_move('next')

			#console.log "top", @topItem.attr('data-index')
			#console.log "bottom", @bottomItem.attr('data-index')
			
			@

		_move: (direction) ->
			# We first move in the direction of the movement until we
			# find a visible item. Then we keep moving from there until
			# we find a non visible item
			extremeA = @_moveWhileVisibilityIs(@topItem, direction, false)
			extremeB = @_moveWhileVisibilityIs(extremeA, direction, true)

			[extremeA, extremeB]


		# Iterates in the specified direction, using item as the start point
		# and keeps moving while its visibility it's like the specified
		_moveWhileVisibilityIs: (item, direction, isVisible) ->
			# TO-DO this could be improved by using binary search
			prevItem = item

			while @_visible(item) == isVisible
				prevItem = item
				# We iterate to the "next" element before
				# adding or removing because that can change
				# the DOM configuration
				item = item[direction]()

				if not isVisible
					@_removeItem(prevItem)
				else
					@_addItem(prevItem)

			# If we have reached the last or first item
			# we return the previous visited 
			if item.length == 0
				item = prevItem

			item

		_visible: (item) ->
			if not item or item.length == 0 then return undefined

			scroll = @_scrollData()
			itemTop = item.position().top + scroll.top

			not (itemTop > scroll.bottom + @visibleMargin or itemTop + item.height() < scroll.top - @visibleMargin)

		_scrollData: ->
			scroll = @ui.scroll[0]

			{
				top : scroll.scrollTop
				height : scroll.scrollHeight
				bottom : scroll.scrollTop + scroll.clientHeight
			}

		# removes a ItemView but keeps its related DOM 
		_removeItem: (item) ->
			itemView = @children._views[item.attr('data-cid')]
			
			if itemView
				# Uncomment if you want to call itemView to unload whatever is needed
				itemView.trigger('visible', false)
				copy = item[0].outerHTML
				$(copy).insertAfter(item)
				@removeChildView(itemView)

		# adds an ItemView making it visible if it was already existing or it creates a
		# new one otherwise
		_addItem: (item) ->
			itemView = @children._views[item.attr('data-cid')]
			if itemView
				itemView.trigger('visible', true)
			else
				@addChildView(@collection.at(item.attr('data-index')))

		_onMouseWheel: (event) ->
			event.preventDefault()
			scroll = @_scrollData()
			deltaY = event.originalEvent.wheelDeltaY

			sign = @_sign(deltaY)

			# scroll movement is clamped
			newDestiny = @scrollTopDestiny + Math.max(Math.abs(deltaY), 80)*sign
			newDestiny = Math.max(Math.min(newDestiny, scroll.height), 0)

			if @scrollTopDestiny != newDestiny
				@scrollTopDestiny = newDestiny

				# we stop the animations and animate the new one
				@ui.scroll
					.css('padding-top', 0)
					.clearQueue()
					.stop()
					.animate({scrollTop: @scrollTopDestiny}, 100, 'easeOutQuad')

				if @scrollTopDestiny == 0
					@ui.scroll
						.animate({'padding-top': 40}, 100)
						.animate({'padding-top': 0}, 150)
				# else if scroll.bottom == scroll.height
					 #TO-DO add bottom animation


		_delayedOnScroll: (event) ->
			scrollTop = event.target.scrollTop

			if not @_visible(@topItem) or not @_visible(@bottomItem)
				@_onScroll(event)

			clearTimeout(@_scrollTimeout)
			@_scrollTimeout = setTimeout(@_onScroll, 200)

		_onScroll: (event) ->
			scroll = @_scrollData()
			@trigger('scroll', scroll)

			#@_updateVisibility(scroll.top - @scrollTop)
			@scrollTop = scroll.top

			if scroll.height - @loadMargin < scroll.bottom
				@trigger('scrollend')

		_sign: (value) ->
			if value > 0 
				return -1
			else if value < 0
				return 1

			return 0
				
				

