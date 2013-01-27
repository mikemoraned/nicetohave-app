window.nicetohave ?= {}

class AppViewModel

  constructor: ->
    @privilege = new nicetohave.Privilege(Trello)
#    @card = new nicetohave.Card("510557f3e002eb8d56002e04", @privilege)
    @card = new nicetohave.Card("5105af6108fa2a6e21000dc5", @privilege)

window.nicetohave.AppViewModel = AppViewModel