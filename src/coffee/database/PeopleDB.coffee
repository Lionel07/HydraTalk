define((require)->
    Message = require("core/Message")
    Conversation = require("core/Conversation")
    Person = require("core/Person")
    class PeopleDB
        instance = null
        class PeopleDatabase
            constructor: ->
                @people = []
                @nextId = 0

            add: (person) ->
                if @people?
                    @people.push(person)
                else
                    @people = [person]

            removeFromName: (name) ->
                for i in @people
                    if i.name is name
                        @removeFromIndex(@people.indexOf(i))
                return

            assignID: (person) ->
                @nextId++
                person.person_id = @nextId
                
            removeFromIndex: (index) -> @people.splice(index, 1)

            findById: (id) ->
                result = (person for person in @people when person.person_id is id)
                return result[0]

            isDuplicate: (a, b) ->
                if a.isUnique? | b.isUnique?
                    return false
                confidence = 0
                threshold = 2

                confidence++ if(a.name is b.name)
                confidence++ if(a.avatar_location is b.avatar_location)
                return confidence >= threshold

            scanDuplicates: (a) ->
                res = false
                person = null
                for i in @people
                    res_s = @isDuplicate(a, i)
                    if res_s is true
                        res = true
                        person = i
                        break
                return {res: res, person: person}

        get: () ->
            instance ?= new PeopleDatabase()
    return PeopleDB
)
