# StoreesView
define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"text!templates/storees.html"
	"views/StoreeView"
	"views/ScrollView"
], ($, _, Backbone, app, template, StoreeView, ScrollView) ->
	class StoreesView extends ScrollView
		itemView: StoreeView,
		className: 'storeer-results-content'
		template: _.template(template)
		# margin that we want to add to the scroll view
		visibleMargin: 1000
		# margin at which we want to load more images
		bottomMargin: 200

		ui:
			scroll: '.storee-collection'

		initialize: ->
			ScrollView.prototype.initialize.apply(@, )
			@on('scroll', @onScroll)

		onScroll: (scroll) ->
			#TO-DO

		loadMore: ->
			if not @pending()
				app.vent.trigger('search:more')

