class PostOffice
    constructor: ->
        @queue = []
        @address = {
            main: 0
            ui: 1
            providers: 2
        }
        @handlers = []
        @mid = 0
    createBlankMessage: ->
        return {
            from: -1
            to: []
            type: "null"
            data: {}
            mid: @mid++
        }
    createMessage: (from, to = [], type = "null", data = {}) ->
        builder = @createBlankMessage()
        builder.from = from
        builder.to = to
        builder.type = type
        builder.data = data
        return builder
    debugPrint: (message) ->
        keyNames = Object.keys(@address)
        recipients = ""
        firstDone = false
        for name in message.to
            recipients += ", " if firstDone
            recipients += keyNames[name]
            firstDone = true
        log = "#{keyNames[message.from]} => [#{recipients}]: (#{message.type}) #{Object.keys(message.data)}"
        debug.log("PostOffice",log)
    tick: => @processMessage() if @queue.length > 0
    registerHandler: (address, handler) -> @handlers[address] = handler
    processMessage: ->
        message = @queue.pop()
        return if message is null
        for recipient in message.to
            if @handlers[recipient]?
                @handlers[recipient](message)
            else
                debug.error("PostOffice", "Can't reach #{Object.keys(@address)[message.to]}")

    send: (message) ->
        @debugPrint(message)
        @queue.push(message) if message isnt null

this.hydra.post = new PostOffice()
