this.hydra = {} unless this.hydra?
hydra = this.hydra
this.hydra.providers = [] unless this.hydra.providers?

class TwitterProvider extends hydra.Provider
    constructor: () ->
        super("Twitter", {
            contacts: yes
            conversations: yes
            group: yes
        })
        @provider_id = 2

    init: () ->
        super()
        @isReady = true

    login: () -> @isLoggedIn = true

    tick: () ->
        hydra.providertask.processUpdate(null, @provider_id)

    write: (input) -> console.log "Write"

    pull: () ->

hydra.providers.push(new TwitterProvider())
