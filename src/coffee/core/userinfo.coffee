this.hydra = {} unless this.hydra?
hydra = this.hydra

class UserInfo
    localStorageDataKey = "UserInfo"

    constructor: -> @user = {name: "", avatar_location: ""}

    save: ->
        localStorage.setItem(localStorageDataKey, JSON.stringify(@user))
        debug.debug("UserInfo", "Saved to local storage")

    load: ->
        data = JSON.parse(localStorage.getItem(localStorageDataKey))
        return unless data?
        @user.name = data.name
        @user.avatar_location = data.avatar_location
        debug.debug("UserInfo", "Loaded from local storage")

hydra.userInfo = new UserInfo()
