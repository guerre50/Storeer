# StoreesView
define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"text!templates/storees.html"
	"views/StoreeView"
], ($, _, Backbone, app, template, StoreeView) ->
	class StoreesView extends Backbone.Marionette.CompositeView
		itemView: StoreeView,
		className: 'storeer-results-content'
		
		template: _.template(template)

		appendHtml: (collectionView, itemView) ->
			collectionView.$(".storee-collection").append(itemView.el)
