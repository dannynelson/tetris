Tetris = require './tetris.coffee'

describe 'tetris', ->
  tetris = null
  beforeEach ->
    tetris = new Tetris()

  it 'exists', ->
    expect(tetris).toBeTruthy()

  describe 'on initialize', ->
    it 'creates a board', ->
      expect(tetris.get('board')).toBeTruthy()    
    it 'sets a score of 0', ->
      expect(tetris.get('score')).toEqual 0    
    it 'sets a level of 1', ->
      expect(tetris.get('level')).toEqual 1

  describe '#makeEmptyBoard', ->
    board = null
    beforeEach ->
      board = tetris.makeEmptyBoard()
    it 'makes a tetris board with 20 columns and 10 rows', ->
      expect(board.length).toEqual 20
      expect(board[0].length).toEqual 10
    it 'makes an empty board', ->
      board.forEach (row)->
        row.forEach (column)->
          expect(column).toEqual 0
