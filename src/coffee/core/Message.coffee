define(->
    class Message
        constructor: (content = "", status = 0,type = "text",
        time = 0, provider = 0) ->
            @status = status
            @content = content
            @content_type = type
            @time = time
            @provider = provider
)
