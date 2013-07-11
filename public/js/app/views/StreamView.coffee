# Stream View
define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"text!templates/stream.html"
	"views/StoreeStripView"
	"views/ScrollView"
], ($, _, Backbone, app, template, StoreeStripView, ScrollView) ->
	class StreamView extends ScrollView
		itemView: StoreeStripView,
		template: _.template(template)
		className: 'storeer-stream-content'

		# margin that we want to add to the scroll view
		visibleMargin: 2000
		# margin at which we want to load more images
		bottomMargin: 2000

		ui:
			scroll: '#storeer-stream'

		initialize: ->
			ScrollView.prototype.initialize.apply(@, )
			_.bindAll @
			@on('scrollend', @loadMore)

		loadMore: ->
			if not @pending()
				app.vent.trigger('search:more')
				

