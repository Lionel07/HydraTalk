this.hydra = {} unless this.hydra?
hydra = this.hydra

class ConversationDatabase
    key = "ConversationDatabase"
    constructor: -> @conversations = []

    add: (conversation) ->
        if @conversations?
            @conversations.push(conversation)
        else
            @conversations = [conversation]

    remove: (conversation) ->
        for i in @conversations
            if @conversations[i] is conversation
                @conversations.splice(i, 1)
                @save()
                return
        return

    load: ->
        data = JSON.parse(localStorage.getItem(key))
        return false unless data?
        for person in data
            @contacts.push(hydra.Person.jsonToObject(person))
        return true
    save: ->
        data = JSON.stringify(@contacts)
        localStorage[key] = data
        return true

    getFromPID: (id) ->
        return null unless @conversations?
        for i in @conversations
            if i.partner is id
                return i
        return null

    parsePacket: (packet) ->
        return false unless packet.delta.conversations?
        conversations = packet.delta.conversations
        shouldRefresh = false
        if packet.updateType is "delta"
            for conversation in conversations
                dbentry = @getFromPID(conversation.partner_id)
                dbentry.addMessage(message) for message in conversation.messages
                shouldRefresh = true

        if packet.updateType is "full"
            for conversation in conversations
                pid = conversation.partner
                dbentry = @getFromPID(pid)
                unless dbentry?
                    @add(conversation)
                    shouldRefresh = true

        return shouldRefresh


this.hydra.database = {} unless this.hydra.database?
hydra.database.conversations = new ConversationDatabase()
