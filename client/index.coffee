$ = require 'jquery'
_ = require 'lodash'
require './rivets-backbone.coffee'
Tetris = require './tetris.coffee'
TetrisView = require './tetris-view.coffee'



$ ->
  new TetrisView(model: new Tetris()).render()
