define((require)->
    Message = require("core/Message")
    Conversation = require("core/Conversation")
    Person = require("core/Person")
    class ConversationDB
        instance = null
        class ConversationDatabase
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
                        return
                return
            getFromPID: (id) ->
                return null unless @conversations?
                for i in @conversations
                    if i.partner is id
                        return i
                return null
        get: () ->
            instance ?= new ConversationDatabase()
    return ConversationDB
)
