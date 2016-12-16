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

    getProviderName: (id) ->
        for provider in hydra.providers
            if provider.provider_id is id
                return provider.name
        return "Unknown"

    processContacts: (data, provider_id) ->
        return unless data?
        for contact in data
            switch contact.status
                when "new"
                    # Initialise the person
                    person = new hydra.Person(contact.name, [provider_id])
                    person.avatar_location = contact.avatar
                    isDuplicate = hydra.database.people.scanDuplicates(person)
                    mapping = null
                    if isDuplicate.res is false
                        id = hydra.database.people.assignID person
                        mapping = {provider: provider_id, uid: contact.uid, id: id}
                        @uidMappings.push mapping
                        hydra.database.people.add person
                    else
                        update = isDuplicate.person
                        update.providers.push(provider_id)
                        mapping = {provider: provider_id, uid: contact.uid, id: update.person_id}
                        @uidMappings.push mapping

                    debug.debug("ProviderDispatch","New Contact (UID #{mapping.uid} -> ID #{mapping.id}), #{if isDuplicate.res then "dupe" else "unique"}")
                    @queueUIRefresh = true
                    hydra.ui.shouldUpdate.conversations = true

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
                    continue if partner_id is 0
                    conv = hydra.database.conversations.getFromPID(partner_id)
                    debug.debug("ProviderDispatch","New Conversation (PID: #{partner_id})")
                    if conv isnt null
                        conv.providers.push(provider_id)
                        @processMessages(conv, conversation.messages, provider_id)
                    else
                        conv = new hydra.Conversation(partner_id, [provider_id], no)
                        conv.startDate = conversation.startDate if conversation.startDate?
                        @processMessages(conv, conversation.messages, provider_id)
                        hydra.database.conversations.add conv
                    @queueUIRefresh = true
                    hydra.ui.shouldUpdate.conversations = true
                    hydra.ui.shouldUpdate.chat = true
                    conv.sort()
                when "update"
                    partner_id = @mapUidtoId(provider_id, conversation.uid)
                    conv = hydra.database.conversations.getFromPID(partner_id)
                    @processMessages(conv, conversation.messages, provider_id)
                    conv.sort()
                    @queueUIRefresh = true
                    hydra.ui.shouldUpdate.conversations = true
                    hydra.ui.shouldUpdate.chat = true

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
