this.hydra = {} unless this.hydra?
hydra = this.hydra

#TODO: Write App core logic

class App
    constructor: ->
        doDebugLog("App", "Init")

hydra.app = new App()
