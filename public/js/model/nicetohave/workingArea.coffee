window.nicetohave ?= {}

class WorkingArea

  constructor: (@privilege) ->
    @list = ko.observable(new nicetohave.List("50f5c98fe0314ccd5500a51d", @privilege))
    @cards = ko.computed(() => @list().cards())

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

window.nicetohave.WorkingArea = WorkingArea