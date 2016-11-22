this.hydra = {} unless this.hydra?
hydra = this.hydra
this.hydra.providers = {} unless this.hydra.providers?

class DummyProvider extends hydra.Provider
    constructor: () ->
        super("Dummy",{
            contacts: yes
            conversations: yes
            group: yes
        })
    pull: () ->

        contacts = [
            new hydra.Person("Test A", null),
            new hydra.Person("Test B", null),
            new hydra.Person("Test C", null)
        ]

        conversations = [
            new hydra.Conversation(),
            new hydra.Conversation()
        ]

        conversations[0].partner = 1
        conversations[0].addMessage(new hydra.Message("Hello?", 1))
        contacts[0].person_id = 1
        conversations[1].partner = 2
        conversations[1].addMessage(new hydra.Message("Hello!", 1))
        contacts[1].person_id = 2
        return {
            packetType: "update",
            updateType: "full",
            status: 0,
            contacts: contacts,
            conversations: conversations
        }

hydra.providers.push(new DummyProvider())
