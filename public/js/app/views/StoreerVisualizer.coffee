define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"text!templates/storeer-visualizer.html"
	"text!templates/comments.html"
	"models/StoreeModel"
], ($, _, Backbone, app, template, commentsTemplate, StoreeModel) ->
	class StoreerVisualizer extends Backbone.Marionette.ItemView
		template: _.template(template)
		strip: '#storeer-frame-strip'
		prevArrow: '#storeer-prev'
		nextArrow: '#storeer-next'
		imagesToLoad: 0
		className: 'storeer-visualizer expanded'
		storeerOptions: '#storeer-options'
		storeerOptionsMobile: '#storeer-options-mobile'
		storeerOptionsContent: '#storeer-options-content'
		frameIndicator: '#frame-indicator'
		comments: '#storee-comments'
		commentsTemplate: _.template(commentsTemplate)

		initialize: ->
			_.bindAll @

			$(window).on('keydown', @onKeyDown)
			$(window).on('resize', @resize)

		onShow: ->
			@loadStoreer(@model)

		events:
			'click .previous': 'previous'
			'click .next': 'next'
			'click .storeer-frame': 'onFrameClick'
			'click .storeer-options': 'onClickOption'
			'transitionend #storeer-frame-strip' : 'onTransitionEnd'
			'click .remove': 'onClickClose'

		onDragOver: (event) ->
			console.log event

		loadStoreer: (storee) ->
			# We remove listeners
			@$el.find('img').off('load', @onImgLoad)

			# Assign new Storee
			@model = storee
			@model.loadExtras()

			@listenTo(@model, 'change:comments', @renderComments)

			@currentFrame = 0
			@imagesToLoad = 5

			@render()

			@$el.find('img').on('load', @onImgLoad)

			# We asign the DOM elements of our view
			@$strip = $(@strip)
			@$frames = @$strip.find("div.item")
			@$prevArrow = $(@prevArrow)
			@$nextArrow = $(@nextArrow)
			@$comments = $(@comments)
			@$frameIndicator = $(@frameIndicator)

			@$storeerOptions = $($(@storeerOptions)[0]).children()
			@$storeerOptionsMobile = $($(@storeerOptionsMobile)[0]).children()
			@$storeerOptionsContent = $($(@storeerOptionsContent)[0]).children()
			@setOptionsOrder()

			@resize()

			@

		setOptionsOrder: ->
			i = 0
			for option in @$storeerOptions
				$($(option)[0]).data('order', i)
				$(@$storeerOptionsMobile[i]).data('order', i)
				i++

		previous: ->
			@moveFrame(-1)

		next: ->
			@moveFrame(1)

		onTransitionEnd: (event) ->
			@resize()

		onLoad: ->
			# We need to wait until all images are loaded
			# to reposition
			@repositionStoree()
			@updateControlArrows()

		onImgLoad: (event) ->
			$img = $(event.target)
			# Effect to make images appear nicer 
			$img.css('margin-top', '0')
			$img.data('ratio', $img.width()/$img.height())
			@resize($img.parent())

			if not --@imagesToLoad then @onLoad()

		onFrameClick: (event) ->
			event.preventDefault()
			event.returnValue = false

			# We move frame according of the relative position 
			order = $(event.currentTarget).data('order')
			@moveFrame(order - @currentFrame)

		onKeyDown: (event) ->
			# We must listen events that doesn't target any other DOM
			# element
			if not event or event.target.localName isnt "body" then return

			code = event.keyCode
			switch code
				when 37 then @previous() #left_arrow
				when 39 then @next() #right_arrow
				when 27 then @onClickClose() #esc

		onClickOption: (event) ->
			@$storeerOptions.filter('div.active').toggleClass('active')
			@$storeerOptionsMobile.filter('div.active').toggleClass('active')
			@$storeerOptionsContent.filter('div.active').toggleClass('active')
			
			target = $(event.currentTarget)
			targetOption = target.data('order')

			$(@$storeerOptionsMobile[targetOption]).addClass('active')
			$(@$storeerOptions[targetOption]).addClass('active')
			$(@$storeerOptionsContent[targetOption]).addClass('active')

		onClickClose: ->
			app.vent.trigger('close:storee')

		moveFrame: (sign) ->
			if sign is 0 then return @

			movement = if sign < 0 then "prev" else "next"
			previousFrame = @getCurrentFrame()
			currentFrame = previousFrame[movement]()

			# We toggle active if inside range
			if currentFrame.length > 0
				previousFrame.toggleClass('active')
				currentFrame.toggleClass('active')

				# Update the current frame
				currentIndicator = @$frameIndicator.find('.active')
				currentIndicator.toggleClass('active', false)
				currentIndicator[movement]().toggleClass('active', true)

				@currentFrame = currentFrame.data('order')

			@repositionStoree()
			@updateControlArrows()

		getCurrentFrame: ->
			$(@$frames[@currentFrame])

		updateControlArrows: ->
			currentFrame = @getCurrentFrame()
			
			# first frame
			if @$frames.first().data('order')  == currentFrame.data('order') 
				@$prevArrow.css('left', -@$prevArrow.width())
			else
				@$prevArrow.css('left', '')

			# We have reached the end
			if @$frames.last().data('order') == currentFrame.data('order') 
				@$el.toggleClass('expanded', false)
				@$nextArrow.css('right', -@$nextArrow.width())
			else
				@$nextArrow.css('right','')


		resize: ->
			_.each(@$frames, @resizeFrame)

			@repositionStoree()

		resizeFrame: (frame) ->
			containerHeight = @$strip.height()
			containerWidth = @$el.width()
			containerRatio = containerWidth / containerHeight
			isLastFrame = @currentFrame == @$frames.length - 1

			$frame = $(frame)
			$img = $frame.find('img')
			imgRatio = $img.data('ratio')

			# Last frame has no image inside
			if imgRatio
				if imgRatio > containerRatio 
					$frame.width(containerWidth)
					newHeight = containerWidth/imgRatio
					$frame.height(newHeight)
					$frame.data('height', newHeight)
				else
					$frame.height(containerHeight)
					$frame.width(containerHeight*imgRatio)
					$frame.data('height', containerHeight)

				$frame.css('top', (containerHeight - $frame.data('height'))/2)

		repositionStoree: ->
			currentFrame = @getCurrentFrame()

			# Reposition Storee
			currentWidth = @$el.width()
			frameWidth = currentFrame.width()
			frameLeftOffset = currentFrame.position().left
			
			@$strip.css('left', (-frameLeftOffset + (currentWidth - frameWidth)/2) + 'px')

			@

		renderComments: ->
			@$comments.html(@commentsTemplate({model: @model.toJSON()}))

			@

		render: ->
			@$el.html(@template({model: @model.toJSON()}))

			@


		remove: ->
			$(window).off('keydown', @onKeyDown)
			$(window).off('resize', @resize)
			Backbone.View.prototype.remove.apply(@)
