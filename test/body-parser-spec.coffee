CallbackComponent = require 'nanocyte-component-callback'
BodyParser = require '../src/body-parser'

describe 'BodyParser', ->
  beforeEach ->
    @sut = new BodyParser

  it 'should exist', ->
    expect(@sut).to.be.an.instanceOf CallbackComponent

  describe '->onEnvelope', ->
    describe 'when called with a JSON string', ->
      beforeEach (done) ->
        envelope =
          message:
            body: '{"cyborg": true}'

        @callback = sinon.spy => done()
        @sut.onEnvelope(envelope, @callback)

      it 'should return the parsed message', ->
        expect(@callback).to.have.been.calledWith null, cyborg: true

    describe 'when called with an XML string', ->
      beforeEach (done) ->
        envelope =
          message:
            body: '<doctor>true</doctor>'

        @callback = sinon.spy => done()
        @sut.onEnvelope(envelope, @callback)

      it 'should return the parsed message', ->
        expect(@callback).to.have.been.calledWith null, doctor: "true"

    describe 'when called with a JSON', ->
      beforeEach (done) ->
        envelope =
          message:
            body: {"intellectual": "bow tie"}

        @callback = sinon.spy => done()
        @sut.onEnvelope(envelope, @callback)

      it 'should return the parsed message', ->
        expect(@callback).to.have.been.calledWith null, {"intellectual": "bow tie"}
