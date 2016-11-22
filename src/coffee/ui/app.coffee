this.hydra = {} unless this.hydra?
hydra = this.hydra
global = window
#TODO: Write App core logic

class App
    tickGuard = false
    constructor: ->
        @messageQueue = []
        @shouldTick = true
        @tickObjects = []
        hydra.app = this unless hydra.app?
        doDebugLog("App", "Created")

    start: ->
        doLog("App", "Starting")
        @setTickrate(4)

    setTickrate: =>
        clearInterval(@tick)
        window.ticksPerSecond = global.tickrate
        setInterval(@tick, 1000/global.tickrate) if @shouldTick

    tick: =>
        return unless tickGuard is false
        tickGuard = true
        @processTasks()
        @doUpdate()
        tickGuard = false
        return

    processTasks: ->
        for task in @tickObjects
            task.ticks-- if task.ticks > 0
            if task.ticks is 0
                status = task.callback(task)
                if task.repeat?
                    task.ticks = task.repeatTo

    doUpdate: ->
        for provider in hydra.providers
            @processProviderPacket(provider.tick())

    processProviderPacket: (packet) ->
        switch packet.packetType
            when "update"
                switch packet.updateType
                    when "full"
                        # TODO: Rewrite logic to be local to the database
                        hydra.database.people.people = packet.contacts
                        hydra.database.conversations.conversations = packet.conversations
                    when "delta"
                        return status
            when "null"
                return
hydra.app = new App()
