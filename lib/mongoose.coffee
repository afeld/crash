mongoose = require 'mongoose'
app = require './app'


app.configure 'development', ->
  mongoose.connect 'localhost', 'crash_dev'

app.configure 'test', ->
  mongoose.connect 'localhost', 'crash_test'


module.exports = mongoose
