# Collection
define [
	'jquery'
	'underscore'
	'backbone'
	'App'
	'models/StoreeModel'
	'localstorage'
], ($, _, Backbone, app, StoreeModel) ->
	class StoreeCollection extends Backbone.Collection
		model: StoreeModel

		localStorage: new Backbone.LocalStorage('storeer-storees')

		initialize: ->
			_.bindAll @

			@maxResults = 20
			@page = 0
			@loading = false

			app.vent.on('search:query', (query) -> 
				@search(query) 
			, @)

			app.vent.on('search:fetch', -> 
				@more()
			, @)

		search: (query) ->
			self = @
			@page = 0

			@fetchStorees(query, (storees) ->
				self.reset(storees)
			)

		more: ->
			self = @
			@fetchStorees(@query, (storees) -> 
				self.add(storees)
			)


		fetchStorees: (query, callback) ->
			if @loading or not callback then return true;

			#@loading = true
			callback([new StoreeModel()])