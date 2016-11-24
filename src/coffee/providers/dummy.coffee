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
        @phase = 0

    init: () ->
        super()
        @isReady = true
        @isInitialised = true

    login: () ->
        @isLoggedIn = true

    tick: () ->
        packet = null
        switch @phase
            when 0
                contacts = [
                    new hydra.Person("Dummy Provider", [@provider_id], 1)
                ]
                conversations = [
                    new hydra.Conversation(1, [@provider_id]),
                ]
                conversations[0].startDate = Date.now() - 1000
                packet = {
                    packetType: "update"
                    updateType: "full"
                    status: 0
                    contacts: contacts
                    conversations: conversations
                }

        return packet
    pull: () ->

        return {
            packetType: "update"
            status: 0
        }

hydra.providers.push(new DummyProvider())
