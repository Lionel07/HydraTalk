this.debug = {}
debug = this.debug

debug.loggingEnabled = true

debug.debug = (module, message) -> console.debug("[#{module}]: #{message}") if debug.loggingEnabled
debug.log = (module, message) -> console.info("[#{module}]: #{message}") if debug.loggingEnabled
debug.error = (module, message) -> console.error("[#{module}]: #{message}") if debug.loggingEnabled
