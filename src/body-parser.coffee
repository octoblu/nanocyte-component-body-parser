ReturnValue = require 'nanocyte-component-return-value'

class BodyParser extends ReturnValue
  onEnvelope: (envelope) =>
    return envelope.message

module.exports = BodyParser
