mongoose = require 'mongoose'


switch process.env.NODE_ENV
  when undefined, 'development'
    mongoose.connect 'localhost', 'crash_dev'
  when 'test'
    mongoose.connect 'localhost', 'crash_test'
  when 'production'
    throw new Error "mongo needs to be configured"


module.exports = mongoose
