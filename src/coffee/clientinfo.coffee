exports = this
exports.config = {} unless exports.config?

checkUA = (r) -> r.test(navigator.userAgent.toLowerCase())

exports.config.clientInfo = {
    isElectron: checkUA(/electron/),
    isChrome: checkUA(/chrome/),
    isFirefox: checkUA(/firefox/),
    isIE: checkUA(/msie/),
    isWindows: checkUA(/windows/),
    isMacOS: checkUA(/macintosh|mac os x/),
    isLinux: checkUA(/linux/)
}
