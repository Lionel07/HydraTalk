this.hydra = {} unless this.hydra?
hydra = this.hydra

class ProviderTask
    constructor: ->
        hydra.post.registerHandler(hydra.post.address.providers, @mail)
        @init()
        @uidMappings = []
        @queueUIRefresh = false
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
            when "pull"
                sendto.pull()
            when "login"
                sendto.login()

    processUpdate: (data, provider_id) ->
        return unless data?
        @processContacts(data.contacts, provider_id)
        @processConversations(data.conversations, provider_id)
        if @queueUIRefresh is true
            @queueUIRefresh = false
            refresh = hydra.post.createMessage(hydra.post.address.providers, [hydra.post.address.ui], "refresh")
            hydra.post.send(refresh)

    processContacts: (data, provider_id) ->
        return unless data?
        for contact in data
            switch contact.status
                when "new"
                    person = new hydra.Person(contact.name, [provider_id])
                    person.avatar_location = contact.avatar
                    id = hydra.database.people.assignID person
                    mapping = {provider: provider_id, uid: contact.uid, id: id}
                    @uidMappings.push mapping
                    hydra.database.people.add person
                    @queueUIRefresh = true

    mapUidtoId: (provider_id, uid) ->
        for mapping in @uidMappings
            if mapping.provider is provider_id
                if uid is mapping.uid
                    return mapping.id
        return 0
    processConversations: (data, provider_id) ->
        return unless data?
        for conversation in data
            switch conversation.status
                when "new"
                    partner_id = @mapUidtoId(provider_id, conversation.uid)
                    if partner_id is 0
                        return
                    newconv = new hydra.Conversation(partner_id, [provider_id], no)
                    @processMessages(newconv, conversation.messages, provider_id)
                    hydra.database.conversations.add newconv
                    @queueUIRefresh = true

                when "update"
                    partner_id = @mapUidtoId(provider_id, conversation.uid)
                    conv = hydra.database.conversations.getFromPID(partner_id)
                    @processMessages(conv, conversation.messages, provider_id)

    processMessages: (conversation, messages, provider_id) ->
        return unless messages?
        for message in messages
            switch message.status
                when "new"
                    m = new hydra.Message()
                    m.status = if message.fromPartner then -1 else 1
                    m.content_type = message.type
                    m.content = message.content
                    m.time = message.time
                    m.provider = provider_id
                    conversation.addMessage(m)
                    @queueUIRefresh = true

hydra.providertask = new ProviderTask()
