everyauth = require 'everyauth'
config = require './config'
User = require './models/user'


everyauth.everymodule.findUserById (userId, callback) ->
    # User.findById(userId, callback);
    # callback has the signature, function (err, user) {...}
    User.findOne _id: userId, callback

everyauth.twitter
  .consumerKey(config.CRASH_TWITTER_KEY)
  .consumerSecret(config.CRASH_TWITTER_SECRET)
  .findOrCreateUser (session, accessToken, accessTokenSecret, twitterUserMetadata) ->
    twitterId = twitterUserMetadata.id
    promise = @Promise()

    User.findOne twitterId: twitterId, (err, user) ->
      if err
        promise.fail err
      else if user
        promise.fulfill user
        # TODO update user
      else
        # new user
        user = new User
          name: twitterUserMetadata.name
          twitterId: twitterId
          accessTokens:
            twitter:
              accessToken: accessToken
              accessTokenSecret: accessTokenSecret
          twitterData: twitterUserMetadata

        user.save (err) ->
          if err
            promise.fail err
          else
            promise.fulfill user

    promise

  .redirectPath('/')


module.exports = everyauth
