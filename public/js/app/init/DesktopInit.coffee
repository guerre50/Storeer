require [
	'jquery'
	'underscore'
	'backbone'
	'routers/DesktopRouter'
	'jqueryui'
	'bootstrap'
	'backbone.validateAll'
], ($, _, Backbone, DesktopRouter) ->
	new DesktopRouter()