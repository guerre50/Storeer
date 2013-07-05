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
		template: _.template(template)
		className: 'landing-container' 

		landingStoree: '#landing-storee'
		landingTexts: '#landing-text'

		initialize: ->
			_.bindAll @
 
		onShow: -> 
			@$landingStoree = $(@landingStoree)
			@$landingTexts = $(@landingTexts)
			@setInterval()

		events:
			'click .landing-storee' : 'onLandingStoreeClick'
			'click .landing-button' : 'onLandingButtonClick'
			'click .previous' : 'previous'
			'click .next' : 'next'

		onLandingStoreeClick: (event) ->
			@selectStoree($(event.currentTarget))
			@clearInterval()

		selectStoree: (storee) ->
			oldActive = @$landingStoree.find('.active')
			oldActive.toggleClass('active')
			$(oldActive.data('text')).toggleClass('active')

			newActive = storee
			newActive.toggleClass('active')
			$(newActive.data('text')).toggleClass('active')

		next: ->
			@clearInterval()
			@animateStoree('next')

		previous: ->
			@clearInterval()
			@animateStoree('prev')

		animateStoree: (movement) ->
			currentActive = @$landingStoree.find('.active')
			newActive = currentActive[movement]()

			if newActive.length > 0
				@selectStoree(newActive)
			else
				@clearInterval()

		setInterval: ->
			animateStoree = @animateStoree
			@storeeInterval = setInterval(->
				animateStoree('next')
			, 2500)

		clearInterval: ->
			clearInterval(@storeeInterval)

		remove: ->
			@clearInterval()

		onLandingButtonClick: (event) ->
			app.router.navigate('storees', {trigger: true})


