this.hydra = {} unless this.hydra?
hydra = this.hydra
global = window
#TODO: Write App core logic

class App
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
        tickGuard = false
        return

    processTasks: ->
        for task in @tickObjects
            task.ticks-- if task.ticks > 0
            if task.ticks is 0
                #doLog("Hydra", "Processing task: #{task.name}...")
                status = task.callback(task)
                #doDebugLog("Hydra", "#{task.name}:#{if status then "Complete" else "Failed"}")
                if task.repeat?
                    task.ticks = task.repeatTo



hydra.app = new App()
