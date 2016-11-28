this.hydra = {} unless this.hydra?
hydra = this.hydra
this.hydra.providers = {} unless this.hydra.providers?

messageTextA = """
Welcome to Hydra Talk!
Hydra Talk is a new messaging client.
It does not contain it's own messaging service.
"""
messageTextB = """
Instead, you add Providers, such as Telegram, Discord, Facebook, Twitter, and so on.
None of these are implemented just yet. Tech demo.
"""
messageTextC = """
Hydra Talk manages all of them and makes it so that you only have to go "I want to talk to my friend".
It takes care of finding out where they last were online.
It also merges all the conversations from every Provider into one big conversation.
"""
messageTextD = """
This makes talking to people easier.
Hydra talk is also completely free. It takes your privacy seriously, too.
Nothing is sent to the Hydra Talk servers. There is no registration, either.
Please see <a href="privacy.html">the privacy statement</a> for more information.
"""

class SystemProvider extends hydra.Provider
    constructor: () ->
        super("System",{
            contacts: yes
            conversations: yes
            group: no
        })
        @provider_id = 0
    pull: () ->
        contacts = [
            new hydra.Person("Hydra Talk", [@provider_id]),
        ]
        contacts[0].person_id = -1
        contacts[0].avatar_location = "images/icons/hydra_talk.png"
        conversations = [
            new hydra.Conversation(-1, [@provider_id]),
        ]

        conversations[0].startDate = Date.now()
        conversations[0].addMessage(new hydra.Message(messageTextA, 0,"text", 0, @provider_id))
        conversations[0].addMessage(new hydra.Message(messageTextB, 0,"text", 0, @provider_id))
        conversations[0].addMessage(new hydra.Message(messageTextC, 0,"text", 0, @provider_id))
        conversations[0].addMessage(new hydra.Message(messageTextD, 0,"text", 0, @provider_id))
        @updatePacket("full", {
            contacts: contacts
            conversations: conversations
        })

    write: (input) ->

hydra.providers.push(new SystemProvider())
