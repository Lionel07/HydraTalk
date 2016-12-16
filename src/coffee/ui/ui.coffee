define((require)->
    log = require('logger')
    $ = require('jquery')
    ConversationDB = require('database/ConversationDB')
    PeopleDB = require('database/PeopleDB')
    Message = require("core/Message")
    PostOffice = require('Engine/postoffice')
    Providers = require('Engine/providers')
    class UI
        instance = null
        class UserInterface
            constructor: ->
                @isSetup = true if localStorage["setupComplete"] is "true"
                @currentConversation = null
                @currentSelectedProvider = 1
                @shouldUpdate = {
                    conversations: yes
                    appbar: yes
                    chat: yes
                }
                @setupSignals()
                #@setupNativeUI()
                @showSetupDialog() if not @isSetup
                ui_backdoor = this
                log.log("UI","Created")


            refresh: =>
                @renderConversationList()
                @displayConversation(@currentConversation) if @currentConversation?

            setupSignals: =>
                $("#conversation-list").on("click", ".conversation-base", (event) ->
                    person_id = Number($(this).attr("person_id"))
                    return if person_id is 0
                    instance.changeConversation(person_id)
                )
                $("#appbar-sendmessage").click((event) =>
                    content = $("#appbar_input").val()
                    return if @currentConversation is null or content is ""
                    return if @currentSelectedProvider is 0
                    @sendMessage(content, "text")
                    @shouldUpdate.conversations = true
                    @shouldUpdate.chat = true
                    @refresh()
                    @scrollChatBottom()
                    $("#appbar_input").val("") # Clear out input field
                )
                $("#appbar-input").keyup((event) ->
                    $("#appbar-sendmessage").click() if event.keyCode is 13
                )
                $("#appbar-menu").click(@signalMenuClick)
                $("#appbar-menu-content").on("click", "li", @signalMenuItemClick)


            setupNativeUI: => log.log("UI", "Native app, modifying UI accordingly")
            showSetupDialog: =>

            changeConversation: (person_id) =>
                convDb = new ConversationDB().get()
                @shouldUpdate.conversations = true
                @shouldUpdate.chat = true
                newConv = convDb.getFromPID(person_id)
                @currentConversation = newConv unless newConv is null
                @refresh()
                @scrollChatBottom()

            sendMessage: ->
                post = new PostOffice().get()
                message = new Message(content, 2, type, Date.now(), @currentSelectedProvider)
                @currentConversation.addMessage(message)

                data = {
                    providers: @currentConversation.providers
                    message: message
                    partner: @currentConversation.partner
                }
                postdata = hydra.post.createMessage(post.address.ui,
                    [post.address.providers], "sent_message", data)
                post.send(postdata)

            renderConversationList: ->
                convDb = new ConversationDB().get()
                if convDb.conversations.length isnt 0
                    sorted_conversations = convDb.conversations.sort((a, b) ->
                        return b.getLastMessage().time - a.getLastMessage().time
                    )
                    $("#conversation-list").html("")
                    for i in sorted_conversations
                        $("#conversation-list").append(@renderConversationListItem(i))
                else
                    return $("#conversation-list").html("<div id='noconversationtext'>No Conversations</div>")


            renderConversationListItem: (i) ->
                personDb = new PeopleDB().get()
                partner = personDb.findById(i.partner)
                last_message = i.getLastMessage()
                if last_message?
                    display_text = "You:" if last_message.status > 0
                    display_text = "System: " if last_message.status is 0
                    display_text = "#{partner.name}: " if last_message.status < 0
                    display_text += last_message.content
                    time = last_message.time
                else
                    display_text = ""

                element = @createConversationElement(i.partner,display_text,time)
                return if element is null
                $(element).addClass("conversation-base-selected") if @currentConversation is i
                return element

            displayConversation: (conversation) =>
                $("chat-messages").html("")
                return unless conversation?
                provider_manager = new Providers().get()
                current_provider = 0
                for message in conversation.messages
                    # Display Provider header
                    if current_provider != message.provider
                        current_provider = message.provider
                        provider_name = provider_manager.getProviderName(current_provider)
                        $("chat-messages").append("<div class='chat-provider-header'>#{provider_name}</div>")
                    $("chat-messages").append(@createMessageElement(message))
                @scrollChatBottom()

            createMessageElement: (message) ->
                return null unless message?
                element = $("<div>").addClass("chat-message")
                $(element).addClass("chat-message-partner") if message.status < 0
                $(element).addClass("chat-message-user") if message.status > 0
                $(element).addClass("chat-message-system") if message.status is 0
                switch message.content_type
                    when "image"
                        message_image = $("<img>").addClass("chat-message-image")
                        message_image.attr("src", message.content)
                        element.append(message_image)
                    when "text"
                        element.append($("<span>#{message.content}</span>"))
                return element

            createConversationElement: (person_id, text, time) ->
                personDb = new PeopleDB().get()
                person = personDb.findById(person_id)
                return null if person is null
                element = $("<div>").addClass("conversation-base").attr("person_id", person_id)
                icon = $("<img>").addClass("conversation-icon").attr("src", person.avatar_location)
                name = $("<div>").addClass("conversation-name").text(person.name)
                blurb = $("<div>").addClass("conversation-blurb").text(text)
                # Calculate time since
                time_since = Date.now() - time
                time_since = 0 if time_since < 0
                scale = 0
                if time_since >= 1000
                    scale = 1
                    if time_since >= 60000
                        scale = 2
                        if time_since >= 3600000
                            scale = 3

                switch scale
                    when 0
                        time_since = "Now"
                    when 1
                        time_since = "#{Math.floor(time_since/1000)}s"
                    when 2
                        time_since = "#{Math.floor(time_since/60000)}m"
                    when 3
                        suffix = ""
                        suffix = "'s"if (time_since/3600000 > 2)
                        time_since = "#{Math.floor(time_since/3600000)} h#{suffix}"

                time = $("<div>").addClass("conversation-time").text(time_since)
                element.append(icon, name, time, blurb)
                return element

            scrollChatBottom: -> $("#chat-messages").scrollTop($("#chat-messages")[0].scrollHeight)

            # Menu stuff
            signalMenuClick: (event) -> $("#appbar-menu-content").toggle()

            signalMenuItemClick: (event) ->
                $("#appbar-menu-content").hide()
                clicked = $(this).attr("data-uri")
                console.log(this)
                switch clicked
                    when "settings"
                        instance.createSettingsDialog()
                    when "debug"
                        instance.createSettingsDialog()
                        #hydra.ui.settings.debug()

            mail: (message) =>
                switch message.type
                    when "refresh"
                        @refresh()

            showSetupDialog: ->
                dialog = @createDialog("dialog-setup", "dialog-medium")
                leftpane = $("<div>").addClass("dialog-panel-left")
                rightpane = $("<div>").addClass("dialog-panel-right")

                leftpanetitle = $("<div>").addClass("dialog-panel-left-titlepanel")
                leftpanetitle.append($("<span>Setup</span>"))

                closebutton = $("<div id='dialog-settings-close'>&times;</div>")

                leftpane.append(leftpanetitle)
                leftpane.append(closebutton)
                dialog.append(leftpane)
                dialog.append(rightpane)

                # Setup Events
                $("#dialog-settings-close").on("click", ()->
                    storage["setupComplete"] = "true"
                    $("#dialog-setup").remove()
                )

            createDialog: (id = "", size = "dialog-large") ->
                return if id is ""
                element = $("<dialogbox>").addClass(size)
                element.attr("id", id)
                $("#dialoghost").append(element)
                return element

            createDialogPanelItem: (text, id) -> $("<div class='dialog-panel-item' id='#{id}' data-uri='#{id}'>#{text}</div>")
            createDialogListItem: (id, text) -> $("<div class='dialog-panel-list-item' data-uri='#{id}'>#{text}</div>")

            createSettingsDialog: ->
                dialog = @createDialog("dialog-settings", "dialog-large")
                leftpane = $("<div>").addClass("dialog-panel-left")
                rightpane = $("<div>").addClass("dialog-panel-right")

                leftpanetitle =$("<div>Settings</div>").addClass("dialog-panel-left-titlepanel")
                closebutton = $("<div id='dialog-settings-close' data-uri='close'>&times;</div>")

                leftpane.append(leftpanetitle)
                leftpane.append(closebutton)

                leftpane.append(@createDialogPanelItem("General", "d-panel-general"))
                leftpane.append(@createDialogPanelItem("Providers", "d-panel-providers"))
                leftpane.append(@createDialogPanelItem("Layout & Appearence", "d-panel-layout"))
                leftpane.append(@createDialogPanelItem("Chat", "d-panel-chat"))
                leftpane.append(@createDialogPanelItem("Notifications", "d-panel-notifications"))
                leftpane.append(@createDialogPanelItem("Debug", "d-panel-debug"))
                leftpane.append(@createDialogPanelItem("About", "d-panel-about"))

                dialog.append(leftpane)
                dialog.append(rightpane)

                # Setup Events
                $(".dialog-panel-left").on("click", "div",@signalSettingClick)

            signalSettingClick: (event) ->
                clicked = $(this).attr("data-uri")
                console.log(clicked)
                switch clicked
                    when "close"
                        $("#dialog-settings").remove()
                    when "d-panel-debug"
                        hydra.ui.settings.debug()

        get: () -> instance ?= new UserInterface()
    return UI
)
