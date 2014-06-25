# Tetris Model
# {
#   board: [[0,0,0,0,...],[],[], etc]
#   currentPiece: [[0,1], [0,2], [0,3], [0,4]]
#   score: 100
#   level: 5
#   piece: {
#     coordinates: ...
#     center: ...
#   }
# }
# 
# []

# must clone nested array for backbone to pick up change

Backbone = require 'backbone'
_ = require 'lodash'

class TetrisPiece extends Backbone.Model
  initialize: (startPosition) ->
    @set 'center', startPosition
    @set 'coordinates', @generatePiece(startPosition)

  generatePiece: ->
    @generateLine()
    
  generateLine: ->
    center = @get 'center'
    centerCol = center[0]
    centerRow = center[1]
    [
      [centerCol, centerRow - 1]
      [centerCol, centerRow]
      [centerCol, centerRow + 1]
      [centerCol, centerRow + 2]
    ]

  generateLeftL: ->  
  generateRightL: ->  
  generateSquare: ->

  rotatePiece: ->

  getDownCoordinates: ->
    console.log 'getDownCoordinates'
    coordinates = @get 'coordinates'
    _.map coordinates, (coordinate) ->
      [coordinate[0]+1, coordinate[1]]

  moveDown: ->
    console.log 'moveDown'
    @set 'coordinates', @getDownCoordinates()
    @trigger 'moved', @

  getLeftCoordinates: ->
    coordinates = @get 'coordinates'
    _.map coordinates, (coordinate) ->
      [coordinate[0], coordinate[1] - 1]

  getRightCoordinates: ->
    coordinates = @get 'coordinates'
    _.map coordinates, (coordinate) ->
      [coordinate[0], coordinate[1] + 1]



module.exports = class Tetris extends Backbone.Model
  initialize: ->
    @set
      # TODO: Make Board a separate Method
      board: @makeEmptyBoard()
      score: 0
      level: 1
      currentPiece: new TetrisPiece([1,4])

    @putCurrentPieceOnBoard()
    @get('currentPiece').on 'moved', @putCurrentPieceOnBoard, @


  makeEmptyBoard: =>
    _.map _.range(22), (row) -> 
      _.map _.range(10), (column) ->
        false

  resetBoard: =>
    board = @makeEmptyBoard()
    @set board: board

  getBoardClone: =>
    _.map @get('board'), (row) -> row.slice()

  removeCurrentPieceFromBoard: =>
    console.log 'removeCurrentPieceFromBoard'
    currentPieceCoordinates = @get('currentPiece').get('coordinates')
    board = @getBoardClone()
    _.each currentPieceCoordinates, (coordinate) ->
      board[coordinate[0]][coordinate[1]] = false
    @set 'board', board

  putCurrentPieceOnBoard: =>
    console.log 'putCurrentPieceOnBoard'
    currentPieceCoordinates = @get('currentPiece').get('coordinates')
    board = @getBoardClone()
    _.each currentPieceCoordinates, (coordinate) ->
      board[coordinate[0]][coordinate[1]] = true
    @set board: board

  isValidMove: (newCoordinates) =>
    board = @get 'board'
    _.every newCoordinates, (coordinate) =>
      board[coordinate[0]] and board[coordinate[0]][coordinate[1]] is false

  movePieceLeft: =>
  movePieceRight: =>
  movePieceDown: =>
    console.log 'movePieceDown'
    if (@isValidMove(piece.getDownCoordinates()))
      @removeCurrentPieceFromBoard()
      @get('currentPiece').moveDown()


  # get move coordinates
  # test if coordinates are valid
  # if so, update board, otherwise do nothing

