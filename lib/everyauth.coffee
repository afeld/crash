everyauth = require 'everyauth'
config = require './config'
db = require './db'


everyauth.everymodule.findUserById (userId, callback) ->
    # User.findById(userId, callback);
    # callback has the signature, function (err, user) {...}
    callback null, db.users.findById(userId)

everyauth.twitter
  .consumerKey(config.CRASH_TWITTER_KEY)
  .consumerSecret(config.CRASH_TWITTER_SECRET)
  .findOrCreateUser (session, accessToken, accessTokenSecret, twitterUserMetadata) ->
    user = twitterUserMetadata
    user.accessToken = accessToken
    user.accessTokenSecret = accessTokenSecret

    db.users.insert(user)
    user
  .redirectPath('/')


module.exports = everyauth
