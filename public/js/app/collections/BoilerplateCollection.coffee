# Collection
define [
	'jquery'
	'underscore'
	'backbone'
	'models/BoilerplateModel'
], ($, _, Backbone, Model) ->
	class BoilerplateCollection extends Backbone.Collection
		model: Model