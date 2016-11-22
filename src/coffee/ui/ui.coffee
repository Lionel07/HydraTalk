this.hydra = {} unless this.hydra?
hydra = this.hydra

# Define UI constants

conversationlist = "#conversation-list"
chat = "chat-messages"

appbar_sendmessage = "#appbar-sendmessage"
appbar_input = "#appbar-input"
appbar_menu = "#appbar-menu"
appbar_menu_content = "#appbar-menu-content"
appbar_username = "#appbar-username"
appbar_avatar = "#appbar-useravatar"

class UI
    constructor: ->
        @isSetup = false
        @currentConversation = null
        doDebugLog("UI","Created")

    start: ->
        @isSetup = true if localStorage["setupComplete"] is "true"
        @setupSignals()
        @refresh()
        @setupNativeUI() if clientInfo.isElectron
        @showSetupDialog() if not @isSetup

        doDebugLog("UI","Starting")

    refresh: ->
        @updateConversationList()
        @updateAppbarUserInfo()
        @displayConversation(@currentConversation) if @currentConversation?
        doDebugLog("UI","Refreshing")

    setupNativeUI: ->
        doLog("UI", "Native app, modifying UI accordingly")

    setupSignals: ->
        $(conversationlist).on("click", ".conversation-base", @signalConversationClicked)
        $(appbar_sendmessage).click(@signalMessageSent)
        $(appbar_input).keyup((event) ->
            $(appbar_sendmessage).click() if event.keyCode is 13
        )
        $(appbar_menu).click(@signalMenuClick)
        $(appbar_menu_content).on("click", "li", @signalMenuItemClick)
        return true

    updateConversationList: ->
        no_conversations = true
        if hydra.database.conversations.conversations isnt null
            if hydra.database.conversations.conversations.length isnt 0
                no_conversations = false
        if no_conversations
            element = "<div id='noconversationtext'>No Conversations</div>"
            #$(conversationlist).html(element)
            return
        $(conversationlist).html("")
        for i in hydra.database.conversations.conversations
            partner = hydra.database.people.findById(i.partner)
            last_message = i.getLastMessage()
            display_text = "You:" if last_message.status > 0
            display_text = "System: " if last_message.status is 0
            display_text = "#{partner.name}: " if last_message.status < 0
            display_text += last_message.content
            element = @createConversationElement(i.partner,display_text,last_message.time)
            continue if element is null
            $(element).addClass("conversation-base-selected") if @currentConversation is i
            $(conversationlist).append(element)
        return

    updateAppbarUserInfo: ->
        return unless hydra.userInfo.user?
        $(appbar_avatar).attr("src", hydra.userInfo.user.avatar_location)
        $(appbar_username).text(hydra.userInfo.user.name)

    displayConversation: (conversation) ->
        $(chat).html("")
        return unless conversation?
        for message in conversation.messages
            $(chat).append(hydra.ui.createMessageElement(message))
        @scrollChatBottom()

    signalMenuClick: (event) ->
        $(appbar_menu_content).toggle()

    signalMenuItemClick: (event) ->
        $(appbar_menu_content).hide()
        clicked = $(this).attr("data-uri")
        switch clicked
            when "debug"
                window.location.assign("./debug/index.html")
            when "return_to_main"
                window.location.assign("../index.html")

    signalMessageSent: (event) ->
        content = $(appbar_input).val()
        return unless @currentConversation? or content isnt ""
        message = new Message(content, 1, "text", Date.now(), 0)
        hydra.ui.currentConversation.addMessage(message)
        hydra.database.conversations.save()
        hydra.ui.refresh()
        hydra.ui.scrollChatBottom()
        $(appbar_input).val("") # Clear out input field

    signalConversationClicked: (event) ->
        console.log("Conversation Clicked")
        person_id = Number($(this).attr("person_id"))
        return if person_id is 0
        newConversation = hydra.database.conversations.getFromPID(person_id)
        hydra.ui.currentConversation = newConversation unless newConversation is null
        hydra.ui.refresh()
        hydra.ui.scrollChatBottom() unless newConversation is null

    scrollChatBottom: ->
        $(chat).scrollTop($(chat)[0].scrollHeight)

    showSetupDialog: ->
        $("#setup-dialog").show()
        $("#setup-dialog-confirm").click(() ->
            $("#setup-dialog").hide()
            hydra.currentUser.user.name = $("#setup-name").val()
            hydra.currentUser.user.avatar_location = $("#setup-avatar").val()
            hydra.currentUser.save()
            localStorage["setupComplete"] = "true"
            @isSetup = true
            @updateAppbarUserInfo()
        )

    showWarningDialog: ->

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
        person = hydra.database.people.findById(person_id)
        return null if person is null
        element = $("<div>").addClass("conversation-base")
                    .attr("person_id", person_id)
        icon = $("<img>").addClass("conversation-icon")
                    .attr("src", person.avatar_location)
        name = $("<div>").addClass("conversation-name").text(person.name)
        time = $("<div>").addClass("conversation-time").text(time)
        blurb = $("<div>").addClass("conversation-blurb").text(text)
        element.append(icon, name, time, blurb)
        return element

hydra.ui = new UI()
