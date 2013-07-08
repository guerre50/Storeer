# Search View
define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"text!templates/searchbar.html"
], ($, _, Backbone, app, template) ->
	class SearchView extends Backbone.Marionette.ItemView
		template: _.template(template)
		searchbar: '#searchbar'
		searchTerm: '#search-term'

		initialize: ->
			_.bindAll @
			
			app.vent.on('search:end', @onSearchEnd)

		onShow: ->
			@$searchTerm = $(@searchTerm)
			@$searchbar = $(@searchbar)

			@


		events:
			'change #search-term': 'search'

		search: ->
			term = @$searchTerm.val().trim()
			app.vent.trigger('search:term', term)
			@$searchbar.addClass('loading')

		onSearchEnd: ->
			@$searchbar.removeClass('loading')



