window.nicetohave ?= {}

class WorkingArea

  constructor: (board, @privilege) ->

    @board = ko.observable(board)

    @selectedList = ko.observable()

    @cards = ko.computed(() =>
      #      cards = []
      #      for list in @board().lists()
      #        cards = cards.concat(list.cards())
      #      cards
      if @selectedList()?
        @selectedList().cards()
      else
        []
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
    @load()

  saveEdits: =>
    @haveEdits().forEach((h) -> h.saveEdits())

window.nicetohave.WorkingArea = WorkingArea