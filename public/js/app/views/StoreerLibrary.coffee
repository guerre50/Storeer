define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"text!templates/storeer-library.html"
	"views/SearchView"
	"views/StoreesView"
	"controllers/FlickrController"
], ($, _, Backbone, app, template, SearchView, StoreesView, Flickr) ->
	class StoreerLibrary extends Backbone.Marionette.Layout
		template: _.template(template)
		className: 'storeer-library-content'

		initialize: ->
			_.bindAll @


		regions:
			searchBar : '#storeer-searchBar'
			results : '#storeer-results'

		onShow: ->
			@results.show(new StoreesView({collection: app.storees}))
			@searchBar.show(new SearchView())
