define [
	'jquery'
	'underscore'
	'backbone'
], ($, _, Backbone, Model) ->
	class RouteModel extends Backbone.Model
		initialize: ->
			return

		route: ""
		path: ""

		validate: (attributes) ->
			return