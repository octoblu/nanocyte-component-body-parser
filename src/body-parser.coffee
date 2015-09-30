_ = require 'lodash'
async = require 'async'
JSONBig = require 'json-bigint'
traverse = require 'traverse'
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
      callback null, @convertBigIntsToStrings JSONBig.parse data
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

  convertBigIntsToStrings: (data) =>
    traverse(data).forEach (obj) -> # intentionally skinny
      return unless _.isObject obj
      return unless _.has obj, 's', 'c', 'e'
      return unless _.isFunction obj.toString

      @update obj.toString()

module.exports = BodyParser
