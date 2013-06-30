define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"text!templates/storeer-visualizer.html"
	"models/StoreeModel"
], ($, _, Backbone, app, template, StoreeModel) ->
	class StoreerVisualizer extends Backbone.Marionette.ItemView
		template: _.template(template)
		strip: '#storeer-frame-strip'
		prevArrow: '#storeer-prev'
		nextArrow: '#storeer-next'
		dropPanel: '#drop-panel'
		imagesToLoad: 0
		className: 'storeer-visualizer'
		storeerOptions: '#storeer-options'
		storeerOptionsMobile: '#storeer-options-mobile'

		initialize: ->
			_.bindAll @

			$(window).on('resize', @resize)
			app.vent.on('open:storee', @loadStoreer)
			app.vent.on('drag-start:storee', @onDragStart)
			app.vent.on('drag-end:storee', @onDragEnd)

		events:
			'click .previous': 'previous'
			'click .next': 'next'
			'click .storeer-frame': 'onFrameClick'
			'drop': 'onDrop'
			'dragenter  .storeer-visualizer-drop': 'onDragEnter'
			'dragleave .storeer-visualizer-drop': 'onDragLeave'
			'dragover .storeer-visualizer-drop': 'onDragOver'
			'click .storeer-options': 'onClickOption'
			'transitionend #storeer-frame-strip' : 'onTransitionEnd'

		loadStoreer: (storee) ->
			# We remove listeners
			@$el.find('img').off('load', @onImgLoad)

			# Assign new Storee
			@model = storee
			@currentFrame = 0
			@imagesToLoad = 5

			@render()

			@$el.find('img').on('load', @onImgLoad)

			@$strip = $(@strip)
			@$frames = @$strip.find("div.item")
			@$prevArrow = $(@prevArrow)
			@$nextArrow = $(@nextArrow)

			@$storeerOptions = $($(@storeerOptions)[0]).children()
			@$storeerOptionsMobile = $($(@storeerOptionsMobile)[0]).children()
			@setOptionsOrder()

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
			@updateFrameOffsets()
			@repositionStoree()
			@updateControlArrows()

		onImgLoad: (event) ->
			$img = $(event.target)
			# Effect to make images appear nicer 
			$img.css('margin-top', '0')
			$img.data('ratio', $img.width()/$img.height())

			if not --@imagesToLoad then @onLoad()

		onDrop: (event) ->
			storee = event.originalEvent.dataTransfer.getData("storee")
			if storee then @loadStoreer(new StoreeModel(storee))

		onDragEnter: (event) ->
			@$el.parent().addClass('drag-over')


		onDragLeave: (event) ->
			@$el.parent().removeClass('drag-over')

		onDragOver: (event) ->
			# This "fixes" a bug in Chrome that prevents
			# drop event from being fired more info: 
			# https://code.google.com/p/chromium/issues/detail?id=168387
			event.preventDefault()

		onDragStart: (event) ->
			@$el.parent().addClass('dragging')

		onDragEnd: (event) ->
			@$el.parent().removeClass('dragging').removeClass('drag-over')

		onFrameClick: (event) ->
			event.preventDefault()
			event.returnValue = false

			# We move frame according of the relative position 
			order = $(event.currentTarget).data('order')
			@moveFrame(order - @currentFrame)

		onClickOption: (event) ->
			@$storeerOptions.filter('div.active').toggleClass('active')
			@$storeerOptionsMobile.filter('div.active').toggleClass('active')
			
			target = $(event.currentTarget)
			targetOption = target.data('order')

			$(@$storeerOptionsMobile[targetOption]).addClass('active')
			$(@$storeerOptions[targetOption]).addClass('active')

		moveFrame: (sign) ->
			if sign is 0 then return @

			movement = if sign < 0 then "prev" else "next"
			previousFrame = @getCurrentFrame()
			currentFrame = previousFrame[movement]()

			# We toggle active if inside range
			if currentFrame.length > 0
				previousFrame.toggleClass('active')
				currentFrame.toggleClass('active')
				@currentFrame = currentFrame.data('order')

			@repositionStoree()
			@updateControlArrows()

		getCurrentFrame: ->
			$(@$frames[@currentFrame])


		resize: ->
			@updateFrameOffsets()
			@repositionStoree()

		updateControlArrows: ->
			currentFrame = @getCurrentFrame()
			
			if @$frames.first().data('order')  == currentFrame.data('order') 
				#@$prevArrow.hide()
				@$prevArrow.css('left', -@$prevArrow.width())
			else
				#@$prevArrow.show()
				@$prevArrow.css('left', '')

			if @$frames.last().data('order') == currentFrame.data('order') 
				#@$nextArrow.hide()
				@$nextArrow.css('right', -@$nextArrow.width())
			else
				#@$nextArrow.show()
				@$nextArrow.css('right','')

		updateFrameOffsets: ->
			if not @$frames then return
			# We recompute left offset due to possible size changes
			i = 0
			for frame in @$frames
				$frame = $(frame)
				$frame.data('left', i)
				i += $frame.width()
			
		repositionStoree: ->
			if not @model then return

			currentFrame = @$frames.filter('div.active')

			# Reposition Storee
			currentWidth = @$el.width()
			frameWidth = currentFrame.width()
			frameLeftOffset = currentFrame.data('left')

			# TO-DO Try to find a way to do it with css. 
			# Keeping aspect ratio.
			_.each(@$frames, (frame)-> 
				$frame = $(frame)
				$image = $frame.find("img")

				$image.width($image.height()*$image.data('ratio'))
			)
			
			@$strip.css('left', (-frameLeftOffset + (currentWidth - frameWidth)/2) + 'px')

			@

		render: ->
			if @model
				@$el.html(@template({model: @model.toJSON()}))
				@$el.parent().removeClass('closed')
			else
				@$el.html(@template({model: {}}))
				@$dropPanel = $(@dropPanel)
			@

		onShow: ->
			#if not @model then @$el.parent().addClass('closed')

		remove: ->
			$(window).off('resize', @resize)
			Backbone.View.prototype.remove.apply(@)
