this.hydra = {} unless this.hydra?
hydra = this.hydra
this.hydra.providers = {} unless this.hydra.providers?

reverseString = (str) ->
    splitString = str.split("")
    reverseArray = splitString.reverse()
    joinArray = reverseArray.join("")
    return joinArray

welcomeMessage = """
Hello there! This is a Developer Chat bot. Send a message to get a response!
"""

class DebugChatBotProvider extends hydra.Provider
    constructor: () ->
        super("(Debug) Chat Bot", {
            contacts: yes
            conversations: yes
            group: yes
        })
        @provider_id = 65535
        @phase = 0
        @lastMessage = null

    init: () ->
        super()
        @isReady = true

    tick: () =>
        packet = null
        switch @phase
            when 0
                contacts = [
                    new hydra.Person("[Bot] Mirror", [@provider_id], 1)
                ]
                conversations = [
                    new hydra.Conversation(1, [@provider_id]),
                ]
                conversations[0].startDate = Date.now() - 1000
                conversations[0].addMessage(new hydra.Message(welcomeMessage, -1, "text", Date.now(), @provider_id))
                packet = @updatePacket("full", {
                    contacts: contacts
                    conversations: conversations
                })
                @phase = 1
            when 1
                packet = @nullPacket()
                @phase = 1
            when 2
                message = reverseString(@lastMessage.message.content)
                packet = @updatePacket("delta", {
                    conversations: [
                        {
                            partner_id: 1
                            messages: [
                                message = new hydra.Message("#{message}", -1, "text", Date.now(), @provider_id)
                            ]
                        }
                    ]
                })
                @phase = 1
        return packet

    write: (input) ->
        @lastMessage = input.data
        @phase = 2

    pull: () ->
        @nullPacket()

hydra.providers.push(new DebugChatBotProvider())
