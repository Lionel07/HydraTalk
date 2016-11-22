this.hydra = {} unless this.hydra?
hydra = this.hydra
this.hydra.providers = [] unless this.hydra.providers?

class hydra.Provider
    constructor: (name, support) ->
        @name = name
        @support = support

    init: () ->

    login: () ->

    write: (packet) ->

    pull: () ->
        return {
            packetType: "update",
            updateType: "full",
            status: 0
        }

    tick: () ->
        @pull()
