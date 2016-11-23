exports = this
exports.config = {} unless exports.config?
exports.config.tickrate = {
    ticksPerSecond: 4,
    idleTickrate: 2,
    focusTickrate: 4,
    turboTickrate: 16,
    tickFromSeconds: (seconds) -> seconds * ticksPerSecond
}
