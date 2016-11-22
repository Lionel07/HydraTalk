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
            {ticks: 2, repeatTo: 200, repeat: yes, callback: @doUpdate, name: "Update Providers"}
        ]
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
                switch packet.updateType
                    when "full"
                        # TODO: Rewrite logic to be local to the database
                        if packet.contacts isnt hydra.database.people.people
                            doRefresh = true
                        hydra.database.people.people = packet.contacts
                        hydra.database.conversations.conversations = packet.conversations
                    when "delta"
                        return status
            when "null"
                return

        hydra.ui.refresh() if doRefresh
hydra.app = new App()
