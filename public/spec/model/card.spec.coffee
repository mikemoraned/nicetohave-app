describe 'Card', ->

  describe 'initial state', ->

    it 'cannot be created without an id', ->
      expect(-> new nicetohave.Card()).toThrow({ message: "Not a valid card id: 'undefined'" })

    it 'must only accept an id of the right format (alphanumeric)', ->
      expect(-> new nicetohave.Card("  csdc  scd")).toThrow({ message: "Not a valid card id: '  csdc  scd'" })

    it 'must only accept an id of the right length (24  )', ->
      expect(-> new nicetohave.Card("4eea503d91e31d174600")).toThrow({ message: "Not a valid card id: '4eea503d91e31d174600'" })

    it 'has an empty name', ->
      card = new nicetohave.Card("4eea503d91e31d174600008f")
      expect(card.name()).toBe ""

    it 'has an id', ->
      card = new nicetohave.Card("4eea503d91e31d174600008f")
      expect(card.id()).toBe "4eea503d91e31d174600008f"

    it 'has a created load status', ->
      card = new nicetohave.Card("4eea503d91e31d174600008f")
      expect(card.loadStatus()).toBe "created"

  describe 'loading', ->

    trello = null

    beforeEach ->
      trello = {
        cards: {
          get: (id, params, successFn, errorFn) ->
        }
      }

    it 'when asked to load, loads name', ->
      privilige = new nicetohave.Privilege(trello)
      card = new nicetohave.Card("4eea503d91e31d174600008f", privilige)

      spyOn(trello.cards, 'get')

      card.load()

      expect(trello.cards.get).toHaveBeenCalled()

