mongoose = require '../mongoose'
timestamps = require 'mongoose-timestamp'
LocationSchema = require './location'


UserSchema = mongoose.Schema
  name: 'string'
  # TODO validate uniqueness
  twitterId: 'string'
  # see http://docs.mongodb.org/manual/core/geospatial-indexes/#multi-location-documents
  locations: [LocationSchema]
  accessTokens:
    twitter:
      accessToken: 'string'
      accessTokenSecret: 'string'
  twitterData: 'mixed'

UserSchema.plugin timestamps


# callback receives (err, user)
UserSchema.statics.createOrUpdateFromTwitter = (twitterUserMetadata, callback) ->
  twitterId = twitterUserMetadata.id
  this.findOne twitterId: twitterId, (err, user) ->
    if err
      callback err
    else if user
      # TODO update user
      callback null, user
    else
      # new user
      user = new this
        name: twitterUserMetadata.name
        twitterId: twitterId
        accessTokens:
          twitter:
            accessToken: accessToken
            accessTokenSecret: accessTokenSecret
        twitterData: twitterUserMetadata

      user.save (err) ->
        callback err, user


module.exports = mongoose.model 'User', UserSchema
