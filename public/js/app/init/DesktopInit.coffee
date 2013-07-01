require [
	'jquery'
	'underscore'
	'backbone'
	'routers/DesktopRouter'
	'App'
    'collections/StoreeCollection'
	'less!desktop'
	'jqueryui'
	'bootstrap'
	'backbone.validateAll'
], ($, _, Backbone, DesktopRouter, app, StoreeCollection) ->
	app.start
        storee: new StoreeCollection()

    window.app = app
	app.router = new DesktopRouter()