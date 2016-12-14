this.hydra = {} unless this.hydra?
hydra = this.hydra

hydra.ui.settings = {}

hydra.ui.settings.debug = () ->
    panel = $(".dialog-panel-right")
    panel.html("")

    header = $("<div>").addClass("dialog-panel-header").text("Debug")
    list = $("<div>").addClass("dialog-panel-list")
    contactsdb = $("<div>").addClass("dialog-panel-list-item")
    conversationdb = $("<div>").addClass("dialog-panel-list-item")
    message_count = $("<div>").addClass("dialog-panel-list-item")
    clear_all = $("<div>").addClass("dialog-panel-list-item")
    messages_total = 0
    for conversation in hydra.database.conversations.conversations
        messages_total += conversation.messages.length

    contact_text = "ContactsDB: #{hydra.database.people.people.length} people, Next ID: #{hydra.database.people.nextId}"
    conversation_text = "ConversationsDB: #{hydra.database.conversations.conversations.length} conversations"
    message_text = "Messages: #{messages_total} in total"

    contactsdb.text(contact_text)
    conversationdb.text(conversation_text)
    message_count.text(message_text)
    clear_all.html("Clear Everything <div class='dialog-panel-switch'></div>")
    list.append(contactsdb)
    list.append(conversationdb)
    list.append(message_count)
    list.append(clear_all)
    panel.append(header)
    panel.append(list)
