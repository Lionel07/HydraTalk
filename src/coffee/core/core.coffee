this.hydra = {} unless this.hydra?
hydra = this.hydra

class hydra.Message
    constructor: (content = "", status = 0,type = "text",
    time = 0, provider = 0) ->
        @status = status
        @content = content
        @content_type = type
        @time = time
        @provider = provider

class hydra.Conversation
    constructor: (partner = 0, providers = [], group = no) ->
        @partner = partner
        @isGroup = group
        @startDate = 0
        @providers = providers
        @messages = []

    addMessage: (message) ->
        @messages.push message if message?

    getLastMessage: -> @messages[@messages.length - 1]
    sort: () ->
        @messages.sort((a, b)->
            a.time - b.time
        )
class hydra.Person
    constructor: (name = "", providers = [], id = 0) ->
        @name = name
        @person_id = id
        @avatar_location = "images/no_avatar.png"
        @providers = providers

    isValid: -> @name isnt "" and @person_id isnt 0
