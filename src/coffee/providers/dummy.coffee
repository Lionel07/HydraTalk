this.hydra = {} unless this.hydra?
hydra = this.hydra
this.hydra.providers = {} unless this.hydra.providers?

class DummyProvider extends hydra.Provider
    constructor: () ->
        super("Dummy", {
            contacts: yes
            conversations: yes
            group: yes
        })
        @provider_id = 65535
        @tickno = 1
        @testperson = 0
    init: () ->
        super()
        @isReady = true
        @isInitialised = true

    login: () ->
        @isLoggedIn = true

    tick: () ->
        @tickno--
        return return {
            packetType: "null",
            status: 0
        } unless @tickno is 0
        @tickno = 1
        @pull()

    pull: () ->
        @testperson++
        return {
            packetType: "update"
            status: 0
            contacts: [
                new hydra.Person("Test #{@testperson}", [@provider_id], @testperson)
            ]
            conversations: [
                new hydra.Conversation(@testperson, [@provider_id], no)
            ]
        }

hydra.providers.push(new DummyProvider())
