# StoreeView
define [
	"jquery"
	"underscore"
	"backbone"
	"App"
	"text!templates/storee.html"
], ($, _, Backbone, app, template) ->
	class StoreeView extends Backbone.Marionette.ItemView
		className: 'storee-summary storeer-col col6 square'

		template: _.template(template)

		events:
			'click': 'click'
			'dragstart': 'onDragStart'
			'dragend': 'onDragEnd'

		initialize: ->
			_.bindAll @

		onDragEnd: (event) ->
			@$el.removeClass('dragging')
			app.vent.trigger('drag-end:storee')

		onDragStart: (event) ->
			@$el.addClass('dragging')
			# In Chrome (at least) we need to access originalEvent to set
			# the correct dataTransfer

			event.originalEvent.dataTransfer.setData("storee",  JSON.stringify(@model.toJSON()))
			app.vent.trigger('drag-start:storee')

		click: ->
			app.vent.trigger('open:storee', @model)
			

