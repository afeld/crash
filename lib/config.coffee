keys = [
  'CRASH_TWITTER_KEY',
  'CRASH_TWITTER_SECRET'
]

keys.forEach (key) ->
  val = process.env[key]
  if !val
    throw new Error "must set #{key}"

  exports[key] = val
