define [
	'jquery'
	'underscore'
	'backbone'
], ($, _, Backbone, Model) ->
	class BoilerplateModel extends Backbone.Model
		initialize: ->
			return

		defaults: 
			attribute: 'boilerplate attribute'

		valide: (attributes) ->
			return