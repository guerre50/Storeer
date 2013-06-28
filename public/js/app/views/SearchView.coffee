# StoreeView
define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"text!templates/searchbar.html"
], ($, _, Backbone, app, template) ->
	class SearchView extends Backbone.Marionette.ItemView
		events:
			'change #searchTerm': 'search'

		template: _.template(template)

		search: ->
			query = $('#searchTerm').val().trim()
			app.vent.trigger('search:query', query)

