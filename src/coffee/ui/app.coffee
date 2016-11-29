this.hydra = {} unless this.hydra?
hydra = this.hydra

#TODO: Write App core logic

class App
    tickGuard = false
    constructor: ->
        @shouldTick = true
        @tickObjects = []

    start: ->
        @init()
        hydra.ui.start()
        @tickObjects = [
            {ticks: 0, repeatTo: 1, repeat: yes, callback: hydra.post.tick, name: "Update Messaging System"}
            {ticks: 0, repeatTo: 1, repeat: yes, callback: hydra.providertask.tick, name: "Update Providers"}
        ]
        hydra.post.registerHandler(hydra.post.address.main, @mail)

    init: ->
        debug.debug("App", "Starting")
        @setTickrate(4)

    setTickrate: =>
        clearInterval(@tick) if @tick?
        setInterval(@tick, 1000/config.tickrate.ticksPerSecond) if @shouldTick

    tick: =>
        return unless tickGuard is false
        tickGuard = true
        @processTasks()
        tickGuard = false
        return

    mail: (message) ->

    processTasks: ->
        for task in @tickObjects
            task.ticks-- if task.ticks > 0
            if task.ticks is 0
                status = task.callback(task)
                if task.repeat?
                    task.ticks = task.repeatTo



hydra.app = new App()
