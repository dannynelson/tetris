another = require "./another.coffee"

describe 'should work', ->
  it 'should gimme dat module', ->
    expect(another).toEqual 2
