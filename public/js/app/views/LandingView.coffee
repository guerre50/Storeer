# View example
define [
	"jquery"
	"underscore"
	"backbone"
	"marionette"
	"App"
	"text!templates/landing.html"
], ($, _, Backbone, Marionette, app, template) ->
	class LandingView extends Backbone.Marionette.ItemView
		className: 'landing-container' 
		template: _.template(template)

		landingStoree: '#landing-storee'
		landingTexts: '#landing-text'

		initialize: ->
			_.bindAll @
 
		onShow: ->
			@$landingStoree = $(@landingStoree)
			@$landingTexts = $(@landingTexts)

		events:
			'click .landing-storee' : 'onLandingStoreeClick'
			'click .landing-button' : 'onLandingButtonClick'

		onLandingStoreeClick: (event) ->
			oldActive = @$landingStoree.find('.active')
			oldActive.toggleClass('active')
			$(oldActive.data('text')).toggleClass('active')

			newActive = $(event.currentTarget)
			newActive.toggleClass('active')
			$(newActive.data('text')).toggleClass('active')

		onLandingButtonClick: (event) ->
			app.router.navigate('explorer', {trigger: true})


