# Mobile/Desktop detection script
((ua, w, d) ->
    # App Environment
    # ---------------
    # Tip: Set to true to turn on "production" mode
    production = false
    filesToLoad
    
    #BoilerplateMVC Helper Methods
    boilerplateMVC = 
      loadCSS: (url, callback) ->
        if url
          link = d.createElement 'link'
          link.type = 'text/css'
          link.rel = 'stylesheet'
          link.href = url
          d.getElementsByTagName('head')[0].appendChild link
          
        if callback then callback()

        return

      loadJS: (file, callback) ->
        script = d.createElement "script"
        script.type = 'text/javascript'

        # IE
        if script.readyState  
          script.onreadystatechange = ->
            if script.readyState is "loaded" or script.readyState is "complete"
              script.onreadystatechange = null
              if callback then callback()
              return
        # Other browsers
        else 
          script.onload = ->
            callback?()

        if (typeof file).toLowerCase() is 'object' and file["data-main"]? 
          script.setAttribute("data-main", file["data-main"])
          script.async = true
          script.src = file.src
        else
          script.src = file

        d.getElementsByTagName('head')[0].appendChild script


      loadFiles: (production, obj, callback) ->
        self = @
        if production
          # Loads the production CSS file(s)
          @.loadCSS obj['prod-css'], ->
            # If there are production JavaScript files to load
            if obj['prod-js']
              # Loads the correct initialization file (which includes Almond.js)
              self.loadJS obj['prod-js'], callback

        else
          # Loads the development CSS file(s)
          @.loadCSS obj['dev-css'], ->
            #if there are development JavaScript files to load
            if obj['dev-js']
              # Loads Require.js and tells Require.js to find the correct intialization file
              self.loadJS obj['dev-js'], callback
    
    # Mobile/Tablet logic
    if (/iPhone|iPod|iPad|Android|BlackBerry|Opera Mini|IEMobile/).test ua
      # Mobile/Tablet CSS and JavaScript files to load
        filesToLoad = 
          # Require.js configuration file that is loaded when in development mode
          "dev-js": 
            "data-main": "js/app/config/config.js"
            "src": "js/libs/require.js"
          # JavaScript initialization file that is also loaded when in development mode
          "dev-init": "js/app/init/MobileInit.js"
          # JavaScript file that is loaded when in production mode
          "prod-js": "js/app/init/MobileInit.min.js"

    # Desktop logic
    else
      # Desktop CSS and JavaScript files to load
        filesToLoad =
          # Require.js configuration file that is also loaded when in development mode
          "dev-js":
            "data-main": "js/app/config/config.js"
            "src": "js/libs/require.js"
          # JavaScript initialization file that is loaded when in development mode
          "dev-init": "js/app/init/DesktopInit.js"
          # JavaScript file that is loaded when in production mode
          "prod-js": "js/app/init/DesktopInit.min.js"

    boilerplateMVC.loadFiles production, filesToLoad, ->
      if not production and window.require
        require [filesToLoad['dev-init']]

    return
)(navigator.userAgent || navigator.vendor || window.opera, window, document)