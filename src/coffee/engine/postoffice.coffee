define((require)->
    log = require('logger')
    class Post
        instance = null
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

            createMessage: (from = 0, to = [], type = "null", data = {}) ->
                builder = {}
                builder.from = from
                builder.to = to
                builder.type = type
                builder.data = data
                return builder

            registerHandler: (address, handler) -> @handlers[address] = handler

            processMessage: ->
                message = @queue.pop()
                return if message is null
                for recipient in message.to
                    if @handlers[recipient]?
                        @handlers[recipient](message)
                    else
                        log.error("PostOffice", "Can't reach #{Object.keys(@address)[message.to]}")

            send: (message) ->
                @debugPrint(message)
                @queue.push(message) if message isnt null

            debugPrint: (message) ->
                keyNames = Object.keys(@address)
                recipients = ""
                firstDone = false
                for name in message.to
                    recipients += ", " if firstDone
                    recipients += keyNames[name]
                    firstDone = true
                log_s = "#{keyNames[message.from]} => [#{recipients}]: (#{message.type}) #{Object.keys(message.data)}"
                log.log("PostOffice",log_s)

            tick: => @processMessage() if @queue.length > 0
        get: ->
            instance ?= new PostOffice()

)
