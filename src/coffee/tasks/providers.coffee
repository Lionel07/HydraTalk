this.hydra = {} unless this.hydra?
hydra = this.hydra

class ProviderTask
    constructor: ->
        hydra.post.registerHandler(hydra.post.address.providers, @mail)
        @init()

    init: ->
        for provider in hydra.providers
            provider.init()

    tick: () ->
        provider.tick() for provider in hydra.providers
        return
    mail: (message) ->
        return if message.type is null
        id = message.data.provider
        for provider in hydra.providers
            if provider.provider_id is id
                sendto = provider
                break
        return unless sendto?
        switch message.type
            when "write"
                sendto.write()


hydra.providertask = new ProviderTask()
