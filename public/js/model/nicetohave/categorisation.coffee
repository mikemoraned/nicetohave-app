window.nicetohave ?= {}

class Position

  hasValue: () -> false
  value: () -> 1.0

class Categorisation

  constructor: (card) ->
    @card = card

  axis: (name) -> new Position()

window.nicetohave.Categorisation = Categorisation