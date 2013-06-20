# MobileInit.coffee
require [
	'jquery'
	'underscore'
	'backbone'
	'routers/MobileRouter'
	'less!mobile'
	'jquerymobile'
	'bootstrap'
	'backbone.validateAll'
], ($, _, Backbone, MobileRouter) ->
	# Prevents all anchor click handling
    $.mobile.linkBindingEnabled = false

    # Disabling this will prevent jQuery Mobile from handling hash changes
    $.mobile.hashListeningEnabled = false

    # Instantiates a new Mobile Router instance
    new MobileRouter()