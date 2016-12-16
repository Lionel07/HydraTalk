define(->
    class Person
        constructor: (name = "", providers = [], id = 0) ->
            @name = name
            @person_id = id
            @avatar_location = "images/no_avatar.png"
            @providers = providers
        isValid: -> @name isnt "" and @person_id isnt 0
)
