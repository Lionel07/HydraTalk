this.hydra = {} unless this.hydra?
hydra = this.hydra

class hydra.Message
    constructor: (content = "", status = 0,type = "text",
    time = 0, service = 0) ->
        @status = status
        @content = content
        @content_type = type
        @time = time
        @service = service
    jsonToObject: (json) ->
        #TODO: Implement

class hydra.Conversation
    constructor: ->
        @partner = 0
        @isGroup = no
        @startDate = 0
        @services = []
        @messages = []

    addMessage: (message) ->
        @messages.push message if message?

    getLastMessage: ->
        @messages[@messages.length - 1]

    jsonToObject: (json) ->
        #TODO: Implement

class hydra.Person
    constructor: (name = "", services = []) ->
        @name = name
        @person_id = 0
        @avatar_location = "images/no_avatar.png"
        @services = services

    isValid: -> @name isnt "" and @person_id isnt 0

    jsonToObject: (json) ->
        ret = new Person()
        ret.name = json.name
        ret.person_id = json.person_id
        ret.avatar_location = json.avatar_location
        for service in json.services
            ret.services.push(hydra.Service.jsonToObject(service))
        return ret

class hydra.Service
    constructor: (name, email, id) ->
        @service_name = name
        @service_id = id
        @user_email = email

    jsonToObject: (json) -> new hydra.Service(json.service_name, json.user_email, json.service_id)
