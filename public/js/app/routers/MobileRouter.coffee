# DesktopRouter
define [
    "jquery"
    "underscore"
    "backbone"
    "models/BoilerplateModel"
    "views/BoilerplateView"
    "collections/BoilerplateCollection"
], ($, _, Backbone, Model, View, Collection) ->
    class MobileRouter extends Backbone.Router
        initialize: ->
            Backbone.history.start()

        routes: 
            "": "index"

        index: ->
            new View()