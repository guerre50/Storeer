# DesktopRouter
define [
    'jquery'
    'underscore'
    'backbone'
    'marionette'
    'App'
    'views/LandingView'
    'views/ExplorerView'
    'views/StreamView'
], ($, _, Backbone, Marionette, app, LandingView, ExplorerView, StreamView) ->
    class DesktopRouter extends Backbone.Marionette.AppRouter
        initialize: ->
            Backbone.history.start()
            
            # This allows to use local or online data depending on users connection
            # Backbone.sync = ->
                #Backbone.ajaxSync.apply(this, arguments)
                #Backbone.localSync.apply(this, arguments)

        routes:
            '': 'landing'
            'storees': 'storees'
            'storees/create': 'createStoree'
            'storees/stream': 'stream'
            'storees/:id': 'storees'
            '*actions': 'landing'

        createStoree: ->
            app.content.show(new ExplorerView())
            app.vent.trigger('create:storee')

        storees: (id) ->
            app.content.show(new ExplorerView())
            app.vent.trigger('search:term', '')

        landing: ->
            app.content.show(new LandingView())

        stream: ->
            app.content.show(new ExplorerView())
            app.vent.trigger('search:term','')


