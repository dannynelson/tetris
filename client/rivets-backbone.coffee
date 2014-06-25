rivets = require 'rivets'

rivets.adapters[':'] =
  subscribe: (obj, keypath, callback) ->
    obj.on('change:' + keypath, callback)
  unsubscribe: (obj, keypath, callback) ->
    obj.off('change:' + keypath, callback)
  read: (obj, keypath) ->
    obj.get(keypath)
  publish: (obj, keypath, value) ->
    obj.set(keypath, value)
