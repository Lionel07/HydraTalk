this.hydra = {} unless this.hydra?
hydra = this.hydra

#TODO: Implement UI code

class UI
    constructor: ->
        doDebugLog("UI","Created")
    start: ->
        doDebugLog("UI","Starting")

hydra.ui = new UI()
