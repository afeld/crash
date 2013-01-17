everyauth = require 'everyauth'
config = require './config'
User = require './models/user'


everyauth.everymodule.findUserById (userId, callback) ->
    # callback has the signature, function (err, user) {...}
    User.findOne _id: userId, callback


everyauth.twitter
  .consumerKey(config.CRASH_TWITTER_KEY)
  .consumerSecret(config.CRASH_TWITTER_SECRET)
  .findOrCreateUser (session, accessToken, accessTokenSecret, twitterUserMetadata) ->
    promise = @Promise()

    User.createOrUpdateFromTwitter twitterUserMetadata, (err, user) ->
      if err
        promise.fail err
      else
        promise.fulfill user

    promise

  .redirectPath('/')


module.exports = everyauth
