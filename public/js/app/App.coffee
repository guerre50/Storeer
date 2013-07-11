define [
    'jquery'
    'underscore'
    'backbone'
    'marionette'
], ($, _, Backbone, Marionette) ->
    class App extends Marionette.Application
            
    app = new App()

    app.addRegions
        header: '#storeer-header'
        content: '#storeer-content'
        footer: '#storeer-footer'

    app.addInitializer (options) ->
        @storees = options.storee
        @storees.fetch()
        $(window).on('resize', (event) -> app.vent.trigger('resize', event))

    app


    

