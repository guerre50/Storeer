# Require.js Configurations
# -------------------------
require.config 
	# Sets the js folder as the base directory for all future relative paths
	baseUrl: './js/app'

	# 3rd party script alias names (Easier to type "jquery" than "libs/jquery, etc")
	paths:
		# Core Libraries
		# --------------
		'jquery': '../libs/jquery'
		'jqueryui': '../libs/jqueryui'
		'jquerymobile': '../libs/jquery.mobile'
		'underscore': '../libs/lodash'
		'backbone': '../libs/backbone'	

		# Plugins
		# -------
		'backbone.validateAll': '../libs/plugins/Backbone.validateAll'
		'bootstrap': '../libs/plugins/bootstrap'
		'text': '../libs/plugins/text'
		'jasminejquery': '../libs/plugins/jasmine-jquery'
		'normalize': '../libs/plugins/normalize'
		'css': '../libs/plugins/require-css'
		'less': '../libs/plugins/require-less'
		'lessc': '../libs/plugins/lessc'

	config:
		'css':
			'baseUrl': './css'
		'less':
			'baseUrl': './css'


	# Sets the configuration for your third party scripts that are not AMD compatible
	shim: 
		"jquerymobile": ["jquery"],
		"bootstrap": ["jquery"],
		"jqueryui": ["jquery"],
		"backbone":
			"deps": ["underscore", "jquery"]
			"exports": "Backbone"
		"backbone.validateAll": ["backbone"]
		"jasminejquery": ["jquery"]
		"css":
			"config": 
				"path": '../../css'