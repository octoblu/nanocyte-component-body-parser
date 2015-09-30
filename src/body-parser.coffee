_ = require 'lodash'
async = require 'async'
xml2js = require('xml2js').parseString
CallbackComponent = require 'nanocyte-component-callback'

class BodyParser extends CallbackComponent
  onEnvelope: (envelope, callback) =>
    {message} = envelope
    {body} = message

    async.parallel [
      async.apply @parseJSON, body
      async.apply @parseXML, body
      async.apply @parsePassthrough, body
    ], (error, results) =>
      return callback error if error?
      callback null, _.first _.compact results


  parseJSON: (data, callback) =>
    try
      callback null, JSON.parse data
    catch error
      callback null

  parseXML: (data, callback) =>
    xml2js data,
      explicitArray: false
      mergeAttrs: true
    , (error, parsedData) =>
      callback null, parsedData

  parsePassthrough: (data, callback) =>
    _.defer callback, null, data

module.exports = BodyParser
