-this.hydra = {} unless this.hydra?
hydra = this.hydra

class Dispatch
    constructor: ->
        @outgoingMessages = []

    processProviders: (task) ->
        for provider in hydra.providers
            doRefresh = false
            packet = provider.tick()
            switch packet.packetType
                when "update"
                    peopleRefresh = hydra.database.people.parsePacket(packet)
                    conversationRefresh = hydra.database.conversations.parsePacket(packet)
                    doRefresh = true if peopleRefresh || conversationRefresh
                when "null"
                    continue
            hydra.ui.refresh() if doRefresh

    processMessageQueue: () =>
        message = @outgoingMessages.shift()
        return unless message?
        provider = null
        for p in hydra.providers
            provider = p if p.provider_id is message.sendto

        packet = {
            packetType: "data"
            type: "message"
            status: 0
            data: message
        }
        provider.write(packet)

    sendMessage: (person_id, message, provider) ->
        @outgoingMessages.push({
            person_id: person_id
            message: message
            sendto: provider
        })
hydra.dispatch = new Dispatch()
