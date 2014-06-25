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
    pieces = ['Line', 'LeftL', 'RightL', 'LeftZag', 'RightZag', 'Triangle', 'Square']
    random = Math.floor(Math.random() * 7)
    this['generate' + pieces[random]]()
    
  generateLine: ->
    center = @get 'center'
    centerRow = center[0]
    centerCol = center[1]
    [
      [centerRow, centerCol - 1]
      [centerRow, centerCol]
      [centerRow, centerCol + 1]
      [centerRow, centerCol + 2]
    ]

  generateLeftL: ->
    center = @get 'center'
    centerRow = center[0]
    centerCol = center[1]
    [
      [centerRow - 1, centerCol]
      [centerRow, centerCol]
      [centerRow, centerCol + 1]
      [centerRow, centerCol + 2]
    ]
  generateRightL: ->
    center = @get 'center'
    centerRow = center[0]
    centerCol = center[1]
    [
      [centerRow - 1, centerCol]
      [centerRow, centerCol]
      [centerRow, centerCol - 1]
      [centerRow, centerCol - 2]
    ]
  generateRightZag: ->
    center = @get 'center'
    centerRow = center[0]
    centerCol = center[1]
    [
      [centerRow, centerCol]
      [centerRow - 1, centerCol]
      [centerRow - 1, centerCol + 1]
      [centerRow, centerCol - 1]
    ]
  generateLeftZag: ->
    center = @get 'center'
    centerRow = center[0]
    centerCol = center[1]
    [
      [centerRow, centerCol]
      [centerRow - 1, centerCol]
      [centerRow - 1, centerCol - 1]
      [centerRow, centerCol + 1]
    ]
  generateTriangle: ->
    center = @get 'center'
    centerRow = center[0]
    centerCol = center[1]
    [
      [centerRow, centerCol]
      [centerRow - 1, centerCol]
      [centerRow, centerCol + 1]
      [centerRow, centerCol - 1]
    ]
  generateSquare: ->
    center = @get 'center'
    centerRow = center[0]
    centerCol = center[1]
    [
      [centerRow, centerCol]
      [centerRow, centerCol + 1]
      [centerRow + 1, centerCol]
      [centerRow + 1, centerCol + 1]
    ]

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


module.exports = class Tetris extends Backbone.Model
  initialize: ->
    @set
      # TODO: Make Board a separate Method
      board: @makeEmptyBoard()
      score: 0
      level: 1

    @createNewPiece()
    @setMoveTimer 1000


  makeEmptyBoard: =>
    _.map _.range(22), (row) -> 
      _.map _.range(10), (column) ->
        false

  getBoardClone: =>
    _.map @get('board'), (row) -> row.slice()

  getBoardCloneWithoutCurrentPiece: =>
    board = @getBoardClone()
    @get('currentPiece').get('coordinates').forEach (coordinate) ->
      board[coordinate[0]][coordinate[1]] = false
    board

  # factor out remove piece logic
  removeCurrentPieceFromBoard: =>
    console.log 'removeCurrentPieceFromBoard'
    board = @getBoardClone()
    # TODO: why doesn't _.each work here?
    @get('currentPiece').get('coordinates').forEach (coordinate) ->
      board[coordinate[0]][coordinate[1]] = false
    @set board: board

  putCurrentPieceOnBoard: =>
    console.log 'putCurrentPieceOnBoard'
    debugger
    currentPieceCoordinates = @get('currentPiece').get('coordinates')
    board = @getBoardClone()
    _.each currentPieceCoordinates, (coordinate) ->
      board[coordinate[0]][coordinate[1]] = true
    @set board: board

  isValidMove: (newCoordinates) =>
    board = @getBoardCloneWithoutCurrentPiece()
    _.every newCoordinates, (coordinate) =>
      board[coordinate[0]] and board[coordinate[0]][coordinate[1]] is false

  # @param {string} direction - 'left', 'right', or 'down'
  movePiece: (direction) =>
    console.log "movePiece#{direction}"
    debugger
    piece = @get('currentPiece')
    if (@isValidMove(piece.getCoordinates(direction)))
      @removeCurrentPieceFromBoard()
      piece.move(direction)

  rotatePiece: =>
    piece = @get('currentPiece')
    if (@isValidMove(piece.getRotateCoordinates()))
      @removeCurrentPieceFromBoard()
      piece.rotate()

  setMoveTimer: (speed) =>
    moveTimer = @get 'moveTimer'
    if moveTimer then clearInterval moveTimer
    moveTimer = setInterval =>
      debugger
      piece = @get 'currentPiece'
      if (@isValidMove(piece.getCoordinates('down')))
        @movePiece 'down'
      else
        @checkForCompletedRows()
        @createNewPiece()
    , speed
    @set moveTimer: moveTimer

  checkForCompletedRows: =>
    # TODO: hacky
    that = @
    board = @getBoardClone()
    completedRows = []
    debugger
    _.each board, (row, i) ->
      completed = _.every row, (column) ->
        column is true
      if completed then completedRows.push i
    _.each completedRows, (completedRow) ->
      debugger
      that.set('score', that.get('score') + 10)
      row = board.splice(completedRow, 1)[0]
      row = _.map row, (column) -> false
      board.unshift row
    @set board: board

  createNewPiece: =>
    debugger
    @set(currentPiece: new TetrisPiece([1,4]))
    @get('currentPiece').on 'change:coordinates', @putCurrentPieceOnBoard
    @putCurrentPieceOnBoard()


