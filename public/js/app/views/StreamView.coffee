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
		className: 'storeer-stream-content'
		template: _.template(template)
		stream: '#storeer-stream'
		storeeOptions: '#strip-options'

		events:
			'mouseenter .storeer-visualizer.expanded' : 'onMouseEnter'
			'mouseleave .storeer-visualizer.expanded' : 'onMouseLeave'
			'click .expand' : 'expand'

		onMouseEnter: (event) ->
			@$storeeOptions.toggleClass('enabled', true)
			@setCurrentStoree($(event.currentTarget))

		onMouseLeave: (event) ->
			$destiny = $(event.toElement)
			# We just remove enabled if mouseleave is not towards the options
			if @$storeeOptions.find($destiny).length == 0 and @$storeeOptions.attr('class') != $destiny.attr('class')
				@$storeeOptions.toggleClass('enabled', false)

		initialize: ->
			_.bindAll @

			app.vent.on('current:storee', @selectStoree)

		selectStoree: (storee) ->
			@$selectedStoree = storee

		onShow: ->
			@$stream = $(@stream)
			@$storeeOptions = $(@storeeOptions)

			@$stream.on('scroll', @onScroll)

		appendHtml: (collectionView, itemView) ->
			collectionView.$(".storeer-stream").append(itemView.el)

		setCurrentStoree: (storee) ->
			@$currentStoree = storee
			@updateOptionsTop()

		updateOptionsTop: ->
			storeeTop = @$currentStoree.position().top
			storeeBottom = @$currentStoree.height() + storeeTop
			scrollTop = @$stream.scrollTop()

			top = storeeBottom - @$storeeOptions.height()

			if top > 0
				top = Math.max(storeeTop, 0)

			@$storeeOptions.css('top', top + scrollTop)

		onScroll: (event) ->
			scroll = event.target
			scrollTop = scroll.scrollTop
			scrollHeight = scroll.scrollHeight

			if scrollTop == 0
				@$stream.animate({'padding-top': 40}, 200).animate({'padding-top': 0}, 150)
			else if parseInt(scrollHeight - scrollTop) == parseInt(scroll.clientHeight)
				# bottom
				console.log "bottom"

			if @$currentStoree
				@updateOptionsTop()

		expand: (event) ->
			app.vent.trigger('open:storee', @$selectedStoree)
				
				

