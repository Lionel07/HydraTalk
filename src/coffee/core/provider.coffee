this.hydra = {} unless this.hydra?
hydra = this.hydra
this.hydra.providers = [] unless this.hydra.providers?

class hydra.Provider
    constructor: (name, support) ->
        @name = name
        @support = support
        @provider_id = 0
    init: () ->

    login: () ->

    write: (packet) ->

    pull: () ->
        return {
            packetType: "null",
            status: 0
        }

    tick: () ->
        @pull()
