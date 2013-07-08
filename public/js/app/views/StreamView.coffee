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

		initialize: ->
			_.bindAll @

		onShow: ->
			@$stream = $(@stream)
			@$stream.on('scroll', @onScroll)

		appendHtml: (collectionView, itemView) ->
			collectionView.$(".storeer-stream").append(itemView.el)

		onScroll: (event) ->
			scroll = event.target
			scrollTop = scroll.scrollTop
			scrollHeight = scroll.scrollHeight

			if scrollTop == 0
				@$stream.animate({'padding-top': 40}, 200).animate({'padding-top': 0}, 150)
			else if parseInt(scrollHeight - scrollTop) == parseInt(scroll.clientHeight)
				# bottom
				console.log "bottom"
				app.vent.trigger('search:more')
				
				

