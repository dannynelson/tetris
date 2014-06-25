window.$ = require('jquery')
require './rivets-backbone-adapter/rivets-backbone.js'
# require './rivets-backbone.coffee'
Tetris = require './tetris.coffee'
TetrisView = require './tetris-view.coffee'

$ ->
  new TetrisView(model: new Tetris()).render()
