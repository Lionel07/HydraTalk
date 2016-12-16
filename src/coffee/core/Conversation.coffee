define(->
    class Conversation
        constructor: (partner = 0, providers = [], group = no) ->
            @partner = partner
            @isGroup = group
            @startDate = 0
            @providers = providers
            @messages = []

        addMessage: (message) -> @messages.push message if message?
        getLastMessage: -> @messages[@messages.length - 1]
        sort: -> @messages.sort((a, b)-> a.time - b.time)
)
