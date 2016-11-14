exports = this

exports.doDebugLog = (module, message) ->
    console.debug("[#{module}]: #{message}")


exports.doLog = (module, message) ->
    console.info("[#{module}]: #{message}")

exports.doLogError = (module, message) ->
    console.error("[#{module}]: #{message}")

checkUA = (r) ->
    r.test(navigator.userAgent.toLowerCase())

exports.clientInfo = {
    isElectron: checkUA(/electron/),
    isChrome: checkUA(/chrome/),
    isFirefox: checkUA(/firefox/),
    isIE: checkUA(/msie/),
    isWindows: checkUA(/windows/),
    isMacOS: checkUA(/macintosh|mac os x/),
    isLinux: checkUA(/linux/)
}

ticksPerSecond = 4

idleTickrate   = 2
focusTickrate  = 4
turboTickrate = 16

tickFromSeconds = (seconds) -> seconds * ticksPerSecond
