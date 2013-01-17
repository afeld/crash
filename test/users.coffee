assert = require 'assert'
User = require '../lib/models/user'

describe 'User', ->
  beforeEach (done) ->
    User.remove {}, (err) ->
      if err
        throw err
      done()

  describe '.create()', ->
    it "should save", (done) ->
      user = new User name: 'bob'
      user.save (err) ->
        if err
          throw err
        done()
