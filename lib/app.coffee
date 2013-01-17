express = require 'express'
everyauth = require './everyauth'


app = express()

# setup middleware
app.use express.bodyParser()
app.use express.cookieParser()
app.use express.session({secret: 'mr ripley'})
app.use everyauth.middleware()
app.use (req, res, next) ->
  # require the user to be logged in
  if req.user
    next()
  else
    res.redirect '/auth/twitter'
    # TODO eventually send back to original URL


require('./routes')(app)

module.exports = app
