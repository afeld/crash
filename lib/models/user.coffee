mongoose = require '../mongoose'
timestamps = require 'mongoose-timestamp'
LocationSchema = require './location'


UserSchema = mongoose.Schema
  name: 'string'
  twitterId: 'string'
  # see http://docs.mongodb.org/manual/core/geospatial-indexes/#multi-location-documents
  locations: [LocationSchema]
  accessTokens:
    twitter:
      accessToken: 'string'
      accessTokenSecret: 'string'
  twitterData: 'mixed'

UserSchema.plugin timestamps


module.exports = mongoose.model 'User', UserSchema
