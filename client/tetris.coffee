# Tetris Model
# {
#   board: [[0,0,0,0,...],[],[], etc]
#   score: 100
#   level: 5
# }
# 

Backbone = require 'backbone'
_ = require 'lodash'

module.exports = class Tetris extends Backbone.Model
  initialize: ->
    @set
      board: @makeEmptyBoard()
      score: 0
      level: 1

  makeEmptyBoard: ->
    _.map _.range(20), (row)-> 
      _.map _.range(10), (column)->
        0

