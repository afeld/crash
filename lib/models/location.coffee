mongoose = require '../mongoose'


# matches schema requirement for http://docs.mongodb.org/manual/core/geospatial-indexes/
LocationSchema = mongoose.Schema
  lat: 'number'
  long: 'number'


module.exports = LocationSchema
