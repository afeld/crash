users = require './users'


module.exports = (app) ->
  app.get '/', (req, res) ->
    users.getNearbyFriends req.user, (err, data) ->
      res.json(err || data)

  app.get '/friends/nearby.json', (req, res) ->
    users.getNearbyFriends req.user, (err, data) ->
      res.json(err || data)
