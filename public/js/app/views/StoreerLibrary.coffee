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
			#app.vent.on('search:term', @searchTerm)


		regions:
			searchBar : '#storeer-searchBar'
			results : '#storeer-results'

		onShow: ->
			@results.show(new StoreesView({collection: app.storees}))
			@searchBar.show(new SearchView())


		searchTerm: (term) ->
			#Flickr.topics(100, 1, @onSearchSuccess, @onSearchFail)

		onSearchFail: (fail) ->
			console.log "fail"

		onSearchSuccess: (results) ->
			app.vent.trigger('search:end')
			#@results.show(new StoreesView({collection: results}))

		flickrToCollection: (results) ->
			return 