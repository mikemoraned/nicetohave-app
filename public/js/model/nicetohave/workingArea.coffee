window.nicetohave ?= {}

class WorkingArea

  constructor: (board, @privilege, @outstanding) ->

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
    @outstanding.reset()
    @outstanding.started()
    @board().load()
    @outstanding.completed()

  discardEdits: =>
    @outstanding.reset()
    @outstanding.started()
    @haveEdits().forEach((h) -> h.discardEdits())
    @board().load()
    @outstanding.completed()

  saveEdits: =>
    @outstanding.reset()
    @outstanding.started()
    @haveEdits().forEach((h) -> h.saveEdits())
    @outstanding.completed()

window.nicetohave.WorkingArea = WorkingArea