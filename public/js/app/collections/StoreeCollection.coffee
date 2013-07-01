# Collection
define [
	'jquery'
	'underscore'
	'backbone'
	'App'
	'models/StoreeModel'
	'controllers/FlickrController'
	'localstorage'
], ($, _, Backbone, app, StoreeModel, flickr) ->
	class StoreeCollection extends Backbone.Collection
		model: StoreeModel

		localStorage: new Backbone.LocalStorage('storeer-storees')

		initialize: ->
			_.bindAll @

			@maxResults = 30
			@page = 1

			app.vent.on('search:more', @more)
			app.vent.on('search:term', @search)

		search: (query) ->
			@page = 0
			@query = query
			@fetchStorees(query, @fetchReset)

		more: ->
			@page++
			@fetchStorees(@query, @fetchMore)

		fetchReset: (storees) ->
			@reset(storees)
			@loading = false

		fetchMore: (storees) ->
			@add(storees)
			@loading = false

		fetchStorees: (query, callback) ->
			if @loading or not callback then return

			@loading = true
			flickr.topics(@maxResults, @page, callback, @fetchFail)
		
		fetchFail: (msg) ->

			console.log "fail"