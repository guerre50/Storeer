define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"text!templates/storeer-library.html"
	"views/SearchView"
	"views/StoreesView"
], ($, _, Backbone, app, template, SearchView, StoreesView) ->
	class StoreerLibrary extends Backbone.Marionette.Layout
		template: _.template(template)
		className: 'storeer-library-content'

		regions:
			searchBar : '#storeer-searchBar'
			results : '#storeer-results'

		onShow: ->
			@results.show(new StoreesView({collection: app.storees}))
			@searchBar.show(new SearchView())
			