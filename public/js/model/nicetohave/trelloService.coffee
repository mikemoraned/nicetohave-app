window.nicetohave ?= {}

class TrelloService
  getBoard: (id) ->
    new nicetohave.Board()

window.nicetohave.TrelloService = TrelloService