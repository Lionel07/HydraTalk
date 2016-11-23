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
    jsonToObject: (json) ->
        #TODO: Implement JSON -> Message Conversion

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

    jsonToObject: (json) ->
        #TODO: Implement JSON -> Conversation Conversion

class hydra.Person
    constructor: (name = "", providers = []) ->
        @name = name
        @person_id = 0
        @avatar_location = "images/no_avatar.png"
        @providers = providers

    isValid: -> @name isnt "" and @person_id isnt 0

    jsonToObject: (json) ->
        ret = new Person()
        ret.name = json.name
        ret.person_id = json.person_id
        ret.avatar_location = json.avatar_location
        ret.providers = json.providers
        return ret
