this.hydra = {} unless this.hydra?
hydra = this.hydra
this.hydra.providers = {} unless this.hydra.providers?

class DummyProvider extends hydra.Provider
    constructor: () ->
        super("Dummy",
        {
            contacts: yes
            conversations: yes
            group: yes
        })
        @dataGotten = false
        @provider_id = 65535
    pull: () ->
        contacts = [
            new hydra.Person("Test A", [@provider_id]),
            new hydra.Person("Test B", [@provider_id]),
            new hydra.Person("Test C", [@provider_id]),
            new hydra.Person("Test D", [@provider_id]),
        ]
        contacts[0].person_id = 1
        contacts[1].person_id = 2
        contacts[2].person_id = 3
        contacts[3].person_id = 4
        conversations = [
            new hydra.Conversation(1, [@provider_id]),
            new hydra.Conversation(2, [@provider_id]),
            new hydra.Conversation(3, [@provider_id]),
            new hydra.Conversation(4, [@provider_id]),
        ]
        conversations[0].addMessage(new hydra.Message("Hello?", -1,"text", 0, @provider_id))
        conversations[0].addMessage(new hydra.Message("Hey, how're you?", 1,"text", 0, @provider_id))
        conversations[0].addMessage(new hydra.Message("Ah I'm fine", -1,"text", 0, @provider_id))
        conversations[1].addMessage(new hydra.Message("Hello!", -1,"text", 0, @provider_id))

        type = if @dataGotten then "null" else "full"
        @dataGotten = true
        return {
            packetType: "update",
            updateType: type,
            status: 0,
            contacts: contacts,
            conversations: conversations
        }

hydra.providers.push(new DummyProvider())
