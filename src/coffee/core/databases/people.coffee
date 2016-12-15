this.hydra = {} unless this.hydra?
hydra = this.hydra

class PeopleDatabase
    constructor: ->
        @people = []
        @nextId = 0

    assignID: (person) ->
        @nextId++
        person.person_id = @nextId

    add: (person) ->
        if @people?
            @people.push(person)
        else
            @people = [person]

    removeFromName: (name) ->
        for i in @people
            if i.name is name
                @deleteIndex(@people.indexOf(i))
        return

    removeFromIndex: (index) -> @people.splice(index, 1)

    findById: (id) ->
        result = (person for person in @people when person.person_id is id)
        return result[0]

    clear: ->
        localStorage["PeopleDatabase"] = null
        @load()

    load: ->
        data = null # TODO: Get JSON database from storage
        return false unless data?
        for person in data
            @people.push(hydra.Person.jsonToObject(person))
        return true

    save: ->
        data = JSON.stringify(@people)
        localStorage["PeopleDatabase"] = data
        return true

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

this.hydra.database = {} unless this.hydra.database?
hydra.database.people = new PeopleDatabase()
