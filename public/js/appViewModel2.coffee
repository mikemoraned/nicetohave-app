window.nicetohave ?= {}

class AppViewModel

  constructor: ->
    @privilege = new nicetohave.Privilege(Trello)
    @cards = ko.observableArray([
      new nicetohave.Card("510557f3e002eb8d56002e04", @privilege),
      new nicetohave.Card("5105af6108fa2a6e21000dc5", @privilege)
    ])
    @categorisations = ko.computed(() =>
      @cards().map (card) -> new nicetohave.Categorisation(card)
    )

window.nicetohave.AppViewModel = AppViewModel