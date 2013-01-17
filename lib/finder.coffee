twitter = require 'ntwitter'
config = require './config'


exports.getNearbyFriends = (user, callback) ->
  tokenObj = user.accessTokens.twitter

  twit = new twitter
    consumer_key: config.CRASH_TWITTER_KEY,
    consumer_secret: config.CRASH_TWITTER_SECRET,
    access_token_key: tokenObj.accessToken,
    access_token_secret: tokenObj.accessTokenSecret

  # TODO _getUsingCursor
  # TODO followers/list
  twit.get '/friends/list.json', include_user_entities: true, (err, data) ->
    if err
      callback err
    else
      nearby = data.users.filter (friend) ->
        # TODO also check friend.status.coordinates and friend.status.place.bounding_box
        (/NY/).test friend.location

      callback null, nearby
