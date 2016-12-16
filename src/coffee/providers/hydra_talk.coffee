define(["Engine/providers", "core/Provider"], (Providers, Provider) ->
    class HydraTalkProvider extends Provider
        constructor: (ref) ->
            super("Hydra Talk", {
                contacts: yes
                conversations: yes
                group: yes
            })
            @provider_id = 1
            @provider_manager = ref
            @nextUpdate = {
                contacts: [
                    {status: "new", name: "Hydra Talk", uid: 1, avatar: "images/icons/hydra_talk.png"}
                ]
                conversations: [
                    {status: "new", uid: 1, startDate: Date.now(), messages: [
                        {status: "new", type: "text", fromPartner: true, time: Date.now(), content: "Welcome to Hydra Talk!"},
                    ]}
                ]
            }
        init: () ->
            super()
            @isReady = true

        login: () ->
            @isLoggedIn = true

        tick: () =>
            @provider_manager.processUpdate(@nextUpdate, @provider_id)
            @nextUpdate = null
        write: (input) ->
            console.log "Write"

        pull: () ->
)
