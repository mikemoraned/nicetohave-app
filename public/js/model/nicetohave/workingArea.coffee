window.nicetohave ?= {}

class WorkingArea

  constructor: (board, @privilege) ->

#    @board = ko.observable(new nicetohave.Board("50f5c98fe0314ccd5500a51b", @privilege))

    @board = ko.observable(board)

    @cards = ko.computed(() =>
      cards = []
      for list in @board().lists()
        cards = cards.concat(list.cards())
      cards
    )

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

  load: =>
    @board().load()

  discardEdits: =>
    @haveEdits().forEach((h) -> h.discardEdits())

  saveEdits: =>
    @haveEdits().forEach((h) -> h.saveEdits())

window.nicetohave.WorkingArea = WorkingArea