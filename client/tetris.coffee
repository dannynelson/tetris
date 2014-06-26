Backbone = require 'backbone'
_ = require 'lodash'
TetrisPiece = require './tetris-piece.coffee'

module.exports = class Tetris extends Backbone.Model
  initialize: ->
    # TODO: Make Board a separate Method
    @set
      board: @makeEmptyBoard()
      completedRows: 0
      score: 0
      level: 1

    @createNewPiece()
    @setMoveTimer()
    @on 'change:level', @setMoveTimer

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
    board = @getBoardClone()
    # TODO: why doesn't _.each work here?
    @get('currentPiece').get('coordinates').forEach (coordinate) ->
      board[coordinate[0]][coordinate[1]] = false
    @set board: board

  putCurrentPieceOnBoard: =>
    currentPieceCoordinates = @get('currentPiece').get('coordinates')
    board = @getBoardClone()
    _.each currentPieceCoordinates, (coordinate) ->
      board[coordinate[0]][coordinate[1]] = true
    @set board: board

  isValidMove: (newCoordinates) =>
    # hack because sometimes coordinates do not exist...
    debugger
    if !@get('currentPiece').get('coordinates')
      return false
    board = @getBoardCloneWithoutCurrentPiece()
    _.every newCoordinates, (coordinate) =>
      board[coordinate[0]] and board[coordinate[0]][coordinate[1]] is false

  # @param {string} direction - 'left', 'right', or 'down'
  movePiece: (direction) =>
    piece = @get('currentPiece')
    if @isValidMove piece.getCoordinates(direction)
      @removeCurrentPieceFromBoard()
      piece.move(direction)

  rotatePiece: =>
    piece = @get('currentPiece')
    if @isValidMove piece.getRotateCoordinates()
      @removeCurrentPieceFromBoard()
      piece.rotate()

  # TODO: clean this up
  setMoveTimer: =>
    level = @get 'level'
    speed = 550 - (level * 50)
    moveTimer = @get 'moveTimer'
    if moveTimer then clearInterval moveTimer
    moveTimer = setInterval =>
      piece = @get 'currentPiece'
      if @isValidMove piece.getCoordinates 'down'
        @movePiece 'down'
      else
        @checkForCompletedRows()
        @updateLevel()
        if @isGameOver()
          @removeTimer()
          alert('Sorry, you lose!')
        else
          @createNewPiece()
    , speed
    @set moveTimer: moveTimer

  removeTimer: =>
    moveTimer = @get 'moveTimer'
    if moveTimer then clearInterval moveTimer

  isGameOver: =>
    board = @get 'board'
    failed = false
    _.each _.range(2,4), (row) ->
      _.each _.range(3,6), (col) ->
        if board[row][col] is true then failed = true
    failed

  checkForCompletedRows: =>
    # TODO: hacky
    that = @
    board = @getBoardClone()
    completedRows = []
    _.each board, (row, i) ->
      completed = _.every row, (column) ->
        column is true
      if completed then completedRows.push i
    _.each completedRows, (completedRow) ->
      that.set('score', that.get('score') + 10)
      row = board.splice(completedRow, 1)[0]
      row = _.map row, (column) -> false
      board.unshift row
    that.set('completedRows', that.get('completedRows') + completedRows.length)
    @set board: board

  updateLevel: =>
    completedRows = @get 'completedRows'
    if completedRows is 0
      @set level: 1
    else if (completedRows >= 1) and (completedRows <= 90)
      @set level: (1 + Math.floor((completedRows - 1) / 10))
    else if completedRows >= 91
      @set level: 10

  createNewPiece: =>
    @set(currentPiece: new TetrisPiece([3,4]))
    @get('currentPiece').on 'change:coordinates', @putCurrentPieceOnBoard
    @putCurrentPieceOnBoard()
