define((require)->
    log = require('logger')
    Message = require("core/Message")
    Conversation = require("core/Conversation")
    Person = require("core/Person")
    Provider = require("core/Provider")
    ConversationDB = require('database/ConversationDB')
    PeopleDB = require('database/PeopleDB')
    PostOffice = require('Engine/postoffice')

    # Include Providers here for now
    HydraTalk = require('providers/hydra_talk')

    class ProvidersTask
        instance = null
        class ProviderManager
            constructor: ->
                @uidMappings = []
                @queueUIRefresh = false
                @providers = []

            init: =>
                @providers.push(new HydraTalk(this))
                for provider in @providers
                    provider.init()
                return
            tick: => provider.tick() for provider in @providers

            recieveMail: (message) ->
                return if message.type is null
                id = message.data.provider
                for provider in @providers
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

            getProviderName: (id) ->
                for provider in @providers
                    if provider.provider_id is id
                        return provider.name
                return "Unknown"

            mapUidtoId: (provider_id, uid) ->
                for mapping in @uidMappings
                    if mapping.provider is provider_id
                        if uid is mapping.uid
                            return mapping.id
                return 0

            processUpdate: (data, provider_id) ->
                return unless data?
                @processContacts(data.contacts, provider_id)
                @processConversations(data.conversations, provider_id)
                if @queueUIRefresh is true
                    post = new PostOffice().get()
                    @queueUIRefresh = false
                    refresh = post.createMessage(post.address.providers, [post.address.ui], "refresh")
                    post.send(refresh)

            processContacts: (data, provider_id) ->
                return unless data?
                contactDB = new PeopleDB().get()
                console.log(contactDB)
                for contact in data
                    switch contact.status
                        when "new"
                            # Initialise the person
                            person = new Person(contact.name, [provider_id])
                            person.avatar_location = contact.avatar
                            isDuplicate = contactDB.scanDuplicates(person)
                            mapping = null
                            if isDuplicate.res is false
                                id = contactDB.assignID person
                                mapping = {provider: provider_id, uid: contact.uid, id: id}
                                @uidMappings.push mapping
                                contactDB.add person
                            else
                                update = isDuplicate.person
                                update.providers.push(provider_id)
                                mapping = {provider: provider_id, uid: contact.uid, id: update.person_id}
                                @uidMappings.push mapping

                            log.debug("ProviderDispatch","New Contact (UID #{mapping.uid} -> ID #{mapping.id}), #{if isDuplicate.res then "dupe" else "unique"}")
                            @queueUIRefresh = true
                            #hydra.ui.shouldUpdate.conversations = true

            processConversations: (data, provider_id) ->
                return unless data?
                conversationDB = new ConversationDB().get()
                for conversation in data
                    switch conversation.status
                        when "new"
                            partner_id = @mapUidtoId(provider_id, conversation.uid)
                            continue if partner_id is 0
                            conv = conversationDB.getFromPID(partner_id)
                            log.debug("ProviderDispatch","New Conversation (PID: #{partner_id})")
                            if conv isnt null
                                conv.providers.push(provider_id)
                                @processMessages(conv, conversation.messages, provider_id)
                            else
                                conv = new Conversation(partner_id, [provider_id], no)
                                conv.startDate = conversation.startDate if conversation.startDate?
                                @processMessages(conv, conversation.messages, provider_id)
                                conversationDB.add conv
                            @queueUIRefresh = true
                            conv.sort()
                        when "update"
                            partner_id = @mapUidtoId(provider_id, conversation.uid)
                            conv = conversationDB.getFromPID(partner_id)
                            @processMessages(conv, conversation.messages, provider_id)
                            conv.sort()
                            @queueUIRefresh = true

            processMessages: (conversation, messages, provider_id) ->
                return unless messages?
                for message in messages
                    switch message.status
                        when "new"
                            m = new Message()
                            m.status = if message.fromPartner then -1 else 1
                            m.content_type = message.type
                            m.content = message.content
                            m.time = message.time
                            m.provider = provider_id
                            conversation.addMessage(m)
                            @queueUIRefresh = true

        get: () ->
            instance ?= new ProviderManager()
    return ProvidersTask
)
