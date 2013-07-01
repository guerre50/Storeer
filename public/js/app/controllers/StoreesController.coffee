define [
	'jquery'
	'underscore'
	'backbone'
	'App'
	'collections/StoreeCollection'
	'model/StoreeModel'
], ($, _, Backbone, app, StoreeModel) ->
	
	search: (term) ->
