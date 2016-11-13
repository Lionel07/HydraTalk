this.hydra = {} unless this.hydra?
hydra = this.hydra

class PeopleDatabase
    constructor: ->
        @contacts = []
        @nextId = 0
    load: ->
        data = null # TODO: Get JSON database from storage
        return false unless data?
        for person in data
            @contacts.push(hydra.Person.jsonToObject(person))
        return true
    save: ->
        data = JSON.stringify(@contacts)
        localStorage["PeopleDatabase"] = data
        return true


#TODO: Add other databases

this.hydra.database = {} unless this.hydra.database?
hydra.database.people = new PeopleDatabase()
