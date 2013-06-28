# DesktopRouter
define [
    'jquery'
    'underscore'
    'backbone'
    'marionette'
    'App'
    'collections/StoreeCollection'
    'views/IndexView'
], ($, _, Backbone, Marionette, app, StoreeCollection, IndexView) ->
    class DesktopRouter extends Backbone.Router
        initialize: ->
            app.start
                storee: new StoreeCollection()

            # We expose app for debugging purposes 
            window.app = app

            Backbone.history.start()
            
            # This allows to use local or online data depending on users connection
            # Backbone.sync = ->
                #Backbone.ajaxSync.apply(this, arguments)
                #Backbone.localSync.apply(this, arguments)

        routes:
            '': 'index'

        index: ->
            app.content.show(new IndexView())


