define(->
    class Provider
        constructor: (name, support) ->
            @name = name
            @support = support
            @provider_id = 0
            @isInitialised = false
            @isLoggedIn = false
            @isReady = false

        init: () -> @isInitialised = true
        login: () ->

        push: () ->

        pull: () ->
            return null

        tick: () -> @pull()

)
