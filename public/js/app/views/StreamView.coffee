# StoreesView
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

		appendHtml: (collectionView, itemView) ->
			collectionView.$(".storeer-stream").append(itemView.el)