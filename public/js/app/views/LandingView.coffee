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
			@setInterval()

		events:
			'click .landing-storee' : 'onLandingStoreeClick'
			'click .landing-button' : 'onLandingButtonClick'
			'mouseenter .landing-promo' : 'onEnterLandingPromo'
			'mouseleave .landing-promo' : 'onLeaveLandingPromo'

		onLandingStoreeClick: (event) ->
			@selectStoree($(event.currentTarget))
			@clearInterval()

		onEnterLandingPromo: (event) ->
			#$(event.currentTarget).addClass('active')

		onLeaveLandingPromo: (event) ->
			#$(event.currentTarget).removeClass('active')

		selectStoree: (storee) ->
			oldActive = @$landingStoree.find('.active')
			oldActive.toggleClass('active')
			$(oldActive.data('text')).toggleClass('active')

			newActive = storee
			newActive.toggleClass('active')
			$(newActive.data('text')).toggleClass('active')

		animateStoree: ->
			currentActive = @$landingStoree.find('.active')
			newActive = currentActive.next()

			if newActive.length > 0
				@selectStoree(newActive)
			else
				@clearInterval()

		setInterval: ->
			animateStoree = @animateStoree
			@storeeInterval = setInterval(->
				animateStoree()
			, 2500)

		clearInterval: ->
			clearInterval(@storeeInterval)

		remove: ->
			@clearInterval()

		onLandingButtonClick: (event) ->
			app.router.navigate('storees', {trigger: true})


