define(()->
    debug = (module, message) -> console.debug("[#{module}]: #{message}")
    log = (module, message) -> console.info("[#{module}]: #{message}")
    error = (module, message) -> console.error("[#{module}]: #{message}")

    return {
        debug: debug
        log: log
        error: error
    }
)
