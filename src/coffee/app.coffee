define((require)->
    log = require('logger')
    PostOffice = require('Engine/postoffice')
    Providers = require('Engine/providers')
    UI = require('ui/ui')
    post = null
    class App
        constructor: ->
            log.debug("App", "Initialised")
            @shouldTick = true
            @tickGuard = false
            @tickObjects = []

        start: ->
            log.debug("App", "Starting")
            @providers = new Providers().get()
            post = new PostOffice().get()
            @ui = new UI().get()
            # Start intialising everything
            post.registerHandler(post.address.mail, @mail)
            post.registerHandler(post.address.ui, @mail)
            @providers.init()

            # Get everything going!
            @tickObjects = [
                {ticks: 0, repeatTo: 1, repeat: yes, callback: post.tick, name: "Update Messaging System"}
                {ticks: 0, repeatTo: 1, repeat: yes, callback: @providers.tick, name: "Update Providers"}
            ]
            @setTickrate(4)

        setTickrate: (rate) =>
            clearInterval(@tick) if @tick?
            setInterval(@tick, 1000/rate) if @shouldTick

        tick: =>
            return unless @tickGuard is false
            @tickGuard = true
            @processTasks()
            @ui.refresh()
            @tickGuard = false
            return

        mail: (message) ->

        processTasks: ->
            for task in @tickObjects
                task.ticks-- if task.ticks > 0
                if task.ticks is 0
                    status = task.callback(task)
                    if task.repeat?
                        task.ticks = task.repeatTo

    return App
)
