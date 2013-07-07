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
            _.bindAll @
            Backbone.history.start()
            
            # This allows to use local or online data depending on users connection
            # Backbone.sync = ->
                #Backbone.ajaxSync.apply(this, arguments)
                #Backbone.localSync.apply(this, arguments)

        navMenu: '#nav-menu'

        routes:
            '': 'landing'
            'storees': 'storees'
            'storees/create': 'createStoree'
            'storees/stream': 'stream'
            'storees/:id': 'storees'
            'home': 'home'
            '*actions': 'landing'

        createStoree: ->
            app.content.show(new ExplorerView())
            app.vent.trigger('create:storee')
            @selectMenu()

        storees: (id) ->
            app.content.show(new ExplorerView())
            app.vent.trigger('search:term', '')
            @selectMenu()

        landing: ->
            app.content.show(new LandingView())
            @selectMenu()

        home: ->
            @stream()
            @selectMenu()
            
        stream: ->
            app.content.show(new ExplorerView())
            app.vent.trigger('search:term','')
            @selectMenu()

        selectMenu: ->
            url = Backbone.history.fragment
            $navMenu = $(@navMenu)
            $navMenu.find(".active").toggleClass('active', false)
            $navMenu.find("a[href$='#{url}']").toggleClass('active', true)




