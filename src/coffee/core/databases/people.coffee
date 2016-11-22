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
        doDebugLog("ContactsDatabase", "Added #{person.name}")

    removeFromName: (name) ->
        for i in @people
            if i.name is name
                @deleteIndex(@people.indexOf(i))
        return

    removeFromIndex: (index) ->
        @people.splice(index, 1)

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


this.hydra.database = {} unless this.hydra.database?
hydra.database.people = new PeopleDatabase()
