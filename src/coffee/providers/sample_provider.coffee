this.hydra = {} unless this.hydra?
hydra = this.hydra
this.hydra.providers = [] unless this.hydra.providers?

class SampleProvider extends hydra.Provider
    constructor: () ->
        super("Sample Provider", {
            contacts: yes
            conversations: yes
            group: yes
        })
        @provider_id = 2
        @nextUpdate = {
            contacts: [
                {status: "new", name: "Sample", uid: 1, avatar: "images/icons/hydra_talk_inverted.png"}
            ]
            conversations: [
                {
                    status: "new", uid: 1, messages: [
                        {status: "new", type: "text", fromPartner: true, time: Date.now() - 100000, content: "Test"}
                    ]
                }
            ]
        }

    init: () ->
        super()
        @isReady = true

    login: () -> @isLoggedIn = true

    tick: () ->
        hydra.providertask.processUpdate(@nextUpdate, @provider_id)
        @nextUpdate = null
    write: (input) -> console.log "Write"

    pull: () ->

hydra.providers.push(new SampleProvider())
