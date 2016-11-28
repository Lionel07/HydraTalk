this.hydra = {} unless this.hydra?
hydra = this.hydra
this.hydra.providers = {} unless this.hydra.providers?

class SampleProvider extends hydra.Provider
    constructor: () ->
        super("Sample Provider", {
            contacts: yes
            conversations: yes
            group: yes
        })
        @provider_id = 65536

    init: () ->
        super()
        @isReady = true

    login: () ->
        @isLoggedIn = true

    tick: () =>
        @pull()

    write: (input) ->
        return true

    pull: () ->
        @nullPacket()
