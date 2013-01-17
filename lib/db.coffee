data =
  users: {}

exports.users =
  findById: (id, callback) ->
    data.users[id]
  insert: (doc) ->
    data.users[doc.id] = doc
