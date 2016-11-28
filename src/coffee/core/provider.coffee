this.hydra = {} unless this.hydra?
hydra = this.hydra
this.hydra.providers = [] unless this.hydra.providers?

class hydra.Provider
    constructor: (name, support) ->
        @name = name
        @support = support
        @provider_id = 0
        @isInitialised = false
        @isLoggedIn = false
        @isReady = false

    init: () ->
        @isInitialised = true
    login: () ->

    push: (packet) ->

    pull: () ->
        return nullPacket

    tick: () -> @pull()

    nullPacket: () ->
        return {
            packetType: "null"
            status: 0
        }

    updatePacket: (type, data) ->
        packet = @nullPacket()
        packet.packetType = "update"
        packet.updateType = type
        packet.delta = data
        return packet
