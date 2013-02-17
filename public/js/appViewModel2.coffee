window.nicetohave ?= {}

class AppViewModel

  constructor: ->
    @privilege = new nicetohave.Privilege(Trello)
    @cards = ko.observableArray([
      new nicetohave.Card("510557f3e002eb8d56002e04", @privilege),
      new nicetohave.Card("5105af6108fa2a6e21000dc5", @privilege)
    ])

    @_cachedCategorisations = {};

    @categorisations = ko.computed(() =>
      @cards().map (card) =>
        if (@_cachedCategorisations[card.id()])
          @_cachedCategorisations[card.id()]
        else
          @_cachedCategorisations[card.id()] = new nicetohave.Categorisation(card)
          @_cachedCategorisations[card.id()]
    )

    @haveEdits = ko.computed(() =>
      @categorisations().filter((c) -> c.hasEdits())
    )

    @hasEdits = ko.computed(() => @haveEdits().length > 0)

  saveEdits: =>
    @haveEdits().forEach((h) -> h.saveEdits())

window.nicetohave.AppViewModel = AppViewModel