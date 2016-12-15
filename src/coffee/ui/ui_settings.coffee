this.hydra = {} unless this.hydra?
hydra = this.hydra

hydra.ui.settings = {}

hydra.ui.settings.debug = () ->
    panel = $(".dialog-panel-right")
    panel.html("")
    messages_total = 0
    providers_total = 0
    conversations_total = hydra.database.conversations.conversations.length
    for conversation in hydra.database.conversations.conversations
        messages_total += conversation.messages.length
        providers_total += conversation.providers.length

    contact_text = """
    Contacts: #{hydra.database.people.people.length} </br>
    Next Contact ID: #{hydra.database.people.nextId}
    """
    conversation_text = """
    Conversations: #{conversations_total} </br>
    Providers Per Conversation (avg): #{providers_total / conversations_total}
    """
    message_text = "Messages: #{messages_total} in total"

    header = $("<div>").addClass("dialog-panel-header").text("Debug")
    list = $("<div>").addClass("dialog-panel-list")
    contactsdb = hydra.ui.createDialogListItem("contacts",contact_text)
    conversationdb = hydra.ui.createDialogListItem("conversations",conversation_text)
    message_count = hydra.ui.createDialogListItem("message_cnt",message_text)

    list.append(contactsdb)
    list.append(conversationdb)
    list.append(message_count)

    panel.append(header)
    panel.append(list)
