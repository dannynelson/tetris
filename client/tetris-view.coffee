Backbone = require 'backbone'
$ = Backbone.$ = require 'jquery'
rivets = require 'rivets'

module.exports = class TetrisView extends Backbone.View
  el: '#tetris'

  initialize: ->
    $(document).on 'keydown', @move

  render: -> rivets.bind(@el, {model: @model})

  move: (e) =>
    console.log 'move'
    switch e.keyCode
      when 32 then @model.rotatePiece()
      when 37 then @model.movePiece('left')
      when 39 then @model.movePiece('right')
      when 40 then @model.movePiece('down')
