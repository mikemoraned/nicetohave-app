describe 'Card', ->

  describe 'initial state', ->

    it 'cannot be created without an id', ->
      expect(-> new nicetohave.Card()).toThrow({ message: "Not a valid card id: 'undefined'" })

    it 'must only accept an id of the right format', ->
      expect(-> new nicetohave.Card("abc")).toThrow({ message: "Not a valid card id: 'abc'" })

    it 'has an empty name on startup', ->
      card = new nicetohave.Card("4eea503d91e31d174600008f")
      expect(card.name()).toBe ""

  describe 'loading', ->

    it 'when ', ->
      card = new nicetohave.Card("4eea503d91e31d174600008f")
      expect(card.name()).toBe ""
