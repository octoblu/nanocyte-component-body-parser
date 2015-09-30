ReturnValue = require 'nanocyte-component-return-value'
BodyParser = require '../src/body-parser'

describe 'BodyParser', ->
  beforeEach ->
    @sut = new BodyParser

  it 'should exist', ->
    expect(@sut).to.be.an.instanceOf ReturnValue

  describe '->onEnvelope', ->
    describe 'when called with an envelope', ->
      it 'should return the message', ->
        expect(@sut.onEnvelope({message: 'anything'})).to.deep.equal 'anything'
