require [
	'jquery'
	'underscore'
	'backbone'
	'routers/DesktopRouter'
	'less!desktop'
	'jqueryui'
	'bootstrap'
	'backbone.validateAll'
], ($, _, Backbone, DesktopRouter) ->
	new DesktopRouter()