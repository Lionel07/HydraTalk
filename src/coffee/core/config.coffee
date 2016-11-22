this.hydra = {} unless this.hydra?
hydra = this.hydra

class Configuration
    constructor: ->
        @app = {
            isSetup: false, #TODO: Migrate from ui.isSetup to config.isSetup
            trayIcon: false,
            autoStart: false
        }
        @notifications = {
            enabled: true,
            native: true,
            sound: true,
            sound_name: "default"
        }
        @chat = {
            send_shortcut: "enter",
            replace_emoji: false,
            adaptWideScreen: true
        }

hydra.config = new Configuration()
