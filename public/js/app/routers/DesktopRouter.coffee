# DesktopRouter
define [
    'jquery'
    'underscore'
    'backbone'
    'marionette'
    'App'
    'views/LandingView'
    'views/ExplorerView'
], ($, _, Backbone, Marionette, app, LandingView, ExplorerView) ->
    class DesktopRouter extends Backbone.Marionette.AppRouter
        initialize: ->
            Backbone.history.start()
            
            # This allows to use local or online data depending on users connection
            # Backbone.sync = ->
                #Backbone.ajaxSync.apply(this, arguments)
                #Backbone.localSync.apply(this, arguments)

        routes:
            '': 'landing'
            'explorer': 'index'

        index: ->
            console.log "index"
            app.content.close()
            app.content.show(new ExplorerView())

        landing: ->
            app.content.show(new LandingView())


