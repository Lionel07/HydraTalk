this.hydra = {} unless this.hydra?
hydra = this.hydra
global = window
#TODO: Write App core logic

class App
    tickGuard = false
    constructor: ->
        @messageQueue = []
        @shouldTick = true
        @tickObjects = [
            {ticks: 0, repeatTo: 20, repeat: yes, callback: @doUpdate, name: "Update Providers"}
        ]
        hydra.app = this unless hydra.app?
        debug.debug("App", "Created")

    start: ->
        @init()
        hydra.ui.start()

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

    processTasks: ->
        for task in @tickObjects
            task.ticks-- if task.ticks > 0
            if task.ticks is 0
                status = task.callback(task)
                if task.repeat?
                    task.ticks = task.repeatTo

    doUpdate: (task) =>
        for provider in hydra.providers
            @processProviderPacket(provider.tick())

    processProviderPacket: (packet) ->
        doRefresh = false
        switch packet.packetType
            when "update"
                peopleRefresh = hydra.database.people.parsePacket(packet)
                conversationRefresh = hydra.database.conversations.parsePacket(packet)
                doRefresh = true if peopleRefresh || conversationRefresh
            when "null"
                return
        hydra.ui.refresh() if doRefresh
hydra.app = new App()
