Backbone = require 'backbone'
_ = require 'lodash'

module.exports = class TetrisPiece extends Backbone.Model
  initialize: (startPosition) ->
    @set 'center', startPosition
    @set 'coordinates', @selectRandomPiece(startPosition)

  selectRandomPiece: ->
    pieces = ['line', 'leftL', 'rightL', 'leftZag', 'rightZag', 'triangle', 'square']
    random = Math.floor(Math.random() * 7)
    @generate pieces[random]
  
  # @param {string} pieceType - either 'line', 'leftL', 'rightL', 'leftZag', 'rightZag', 'triangle', or 'square'
  generate: (pieceType) ->
    center = @get 'center'
    row = center[0]
    col = center[1]
    switch pieceType
      when 'line' then [[row, col - 1], [row, col], [row, col + 1], [row, col + 2]]
      when 'leftL' then [[row - 1, col - 1],[row, col - 1],[row, col],[row, col + 1]]
      when 'rightL' then [[row, col - 1], [row, col], [row, col + 1], [row + 1, col + 1]]
      when 'leftZag' then [[row, col], [row - 1, col], [row - 1, col - 1], [row, col + 1]]
      when 'rightZag' then [[row, col], [row - 1, col], [row - 1, col + 1], [row, col - 1]]
      when 'triangle' then [[row, col], [row - 1, col], [row, col + 1], [row, col - 1]]
      when 'square' then [[row, col], [row, col + 1], [row + 1, col], [row + 1, col + 1]]

  # always rotate clockwise for now
  getRotateCoordinates: =>
    center = @get 'center'
    coordinates = @get 'coordinates'
    # center piece at [0,0]
    coordinates = _.map coordinates, (coordinate) ->
      [coordinate[0] - center[0], coordinate[1] - center[1]]
    # rotate
    coordinates = _.map coordinates, (coordinate) ->
      [coordinate[1], -coordinate[0]]
    # put back in original position
    _.map coordinates, (coordinate) ->
      [coordinate[0] + center[0], coordinate[1] + center[1]]

  rotate: ->
    @set coordinates: @getRotateCoordinates()

  getCoordinates: (direction) ->
    rowOffset = colOffset = 0
    switch direction
      when 'down' then rowOffset = 1
      when 'left' then colOffset = -1
      when 'right' then colOffset = 1
    coordinates = @get 'coordinates'
    _.map coordinates, (coordinate) ->
      [coordinate[0] + rowOffset, coordinate[1] + colOffset]

  move: (direction) ->
    rowOffset = colOffset = 0
    switch direction
      when 'down' then rowOffset = 1
      when 'left' then colOffset = -1
      when 'right' then colOffset = 1
    center = @get 'center'
    @set center: [center[0] + rowOffset, center[1] + colOffset]
    @set 'coordinates', @getCoordinates(direction)
