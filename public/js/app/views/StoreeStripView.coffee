# StoreeView
define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"text!templates/storee-strip.html"
], ($, _, Backbone, app, template) ->
	class StoreeStripView extends Backbone.Marionette.ItemView
		template: _.template(template)
		className: 'storeer-visualizer expanded'

		ui:
			frames: '#storeer-frame-strip .item'
			strip: '#storeer-frame-strip'
			prevArrow: '#storeer-prev'
			nextArrow: '#storeer-next'
			storeerVisualizer: '#storeer-visualizer'
			frameIndicator: '#frame-indicator'

		events:
			'click .previous': 'previous'
			'click .next': 'next'
			'click .storeer-frame': 'onFrameClick'
			'click .storeer-frame-indicator': 'onFrameClick'
			'click .storeer-options': 'onClickOption'
			'click .expand' : 'expand'
			'transitionend #storeer-frame-strip' : 'timeoutResize'
			'mouseenter .storeer-visualizer' : 'onMouseEnter'
			'mouseleave .storeer-visualizer' : 'onMouseLeave'

		visibility: false
		currentFrame: 0
		imagesToLoad: 0
		visibleFrames: 2

		initialize: ->
			_.bindAll @
			@loadStoreer(@model)
			@on('visible', @onVisible)
			app.vent.on('resize', @timeoutResize)

		remove: ->
			clearTimeout(@startTimeout)
			clearTimeout(@resizeTimeout)
			clearTimeout(@loadImagesTimeout)
			@$el.find('img').off('load', @onImgLoad)
			Backbone.View.prototype.remove.apply(@)

		onShow: ->
			@loadStoreer(@model)
			@updateControlArrows()
			@onVisible(true)

		onMouseEnter: ->
			# We wait 0.5 seconds to load all the images of the storee
			@loadImagesTimeout = setTimeout(@renderExtraImages, 500)

			# We wait 2 seconds and then we mark the storee as started
			@startTimeout = setTimeout(@start, 2000)

		start: ->
			@$el.toggleClass('started', true)

		onMouseLeave: ->
			clearTimeout(@loadImages)
			clearTimeout(@startTimeout)
			@$el.toggleClass('started', false)

		expand: ->
			app.vent.trigger('open:storee', @model)
			

		onVisible: (visibility) ->
			if visibility
				@visibility = visibility
				@$el.toggleClass('visible', visibility)
				@repositionStoree()

		loadStoreer: (storee) ->
			$ = @$

			# Assign new Storee
			@model = storee

			@currentFrame = 0
			# TO-DO compute number of images that are visible
			@imagesToLoad = @visibleFrames # @model.get('frames').length
			
			@

		previous: ->
			@setCurrentFrame(@currentFrame-1)

		next: ->
			@setCurrentFrame(@currentFrame+1)

		onImgLoad: (event) ->
			img = event.target
			$img = @$(img)

			# When reusing the img component width and height
			# might appear with wrong values
			tmpImage = new Image()
			tmpImage.src = img.src
			img.setAttribute('data-ratio', tmpImage.width/tmpImage.height)

			$img.toggleClass('loading', false)

			frame = $img.parent()

			@repositionStoree()

		onFrameClick: (event) ->
			# We move frame according of the relative position 
			order = $(event.currentTarget).data('order')
			@setCurrentFrame(order)

			return false

		setCurrentFrame: (frame) ->
			if frame >= 0 and frame < @ui.frames.length
				previousFrame = @getCurrentFrame().toggleClass('active')

				$(@ui.frames[frame]).toggleClass('active')
				currentFrame = @getCurrentFrame()

				# Update the current frame
				@ui.frameIndicator.find('.active').toggleClass('active', false)
				$(@ui.frameIndicator.children()[@currentFrame]).toggleClass('active', true)

				@repositionStoree()
				@updateControlArrows()

			@

		getCurrentFrame: ->
			$ = @$
			@currentFrame = parseInt(@ui.frames.filter('.active').attr('data-order'))

			$(@ui.frames[@currentFrame])

		updateControlArrows: ->
			currentFrame = @getCurrentFrame()
			
			# first frame
			if @ui.frames.first().data('order')  == currentFrame.data('order') 
				@ui.prevArrow.css('left', -@ui.prevArrow.width())
			else
				@ui.prevArrow.css('left', '')

			# We have reached the end
			if @ui.frames.last().data('order') == currentFrame.data('order') 
				@$el.toggleClass('started', false)
				# If we are viewing an exising model (@model.id) then
				# we open the comment zone
				@ui.nextArrow.css('right', -@ui.nextArrow.width())
			else
				@ui.nextArrow.css('right', '')

		timeoutResize: (event) ->
			clearTimeout(@resizeTimeout)
			@resizeTimeout = setTimeout(@resize, 200)

		resize: ->
			_.each(@ui.frames, @resizeFrame)

			@repositionStoree()

		resizeFrame: (frame) ->
			containerHeight = @ui.strip.height()
			containerWidth = @$el.width()
			containerRatio = containerWidth / containerHeight

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
			$ = @$
			currentFrame = @getCurrentFrame()
			
			# Reposition Storee
			currentWidth = @ui.storeerVisualizer.width()
			frameWidth = currentFrame.width()
			frameLeftOffset = currentFrame.position().left

			@ui.strip.css('left', (-frameLeftOffset + (currentWidth - frameWidth)/2) + 'px')

			@

		renderExtraImages: ->
			images = @ui.frames.find('img')
			frames = @model.get('frames')

			@restartImageListeners()

			i = 0
			while i < frames.length
				image = images[i]
				if not image.src
					image.src = frames[i].src
				i++

		restartImageListeners: ->
			# We remove listeners
			@$el.find('img')
				.off('load', @onImgLoad)
				.on('load', @onImgLoad)

		render: ->
			@$el.html(@template(
				model: @model.toJSON()
				visible : @visibility
				visibleFrames: @visibleFrames 
			))

			@restartImageListeners()

			@bindUIElements()

			@
