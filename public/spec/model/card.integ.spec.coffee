describe 'Card integ tests', ->

  describe 'loading from test board', ->

    beforeEach ->
      Trello.deauthorize()

    it 'when asked to load existing card, loads name', ->
      privilege = new nicetohave.Privilege(Trello)
      card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege)

      expect(card.name()).toBe ""

      runs(->card.load())

      waitsFor(->card.loadStatus() == "loaded")

      runs(->
        expect(card.name()).toBe "Test card"
      )

    it 'when asked to load existing card with comments, loads them all', ->
      privilege = new nicetohave.Privilege(Trello)
      card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege)

      runs(->card.load())

      waitsFor(->card.loadStatus() == "loaded")

      runs(->
        expect(card.comments().length).toEqual(1)
        expect(card.comments()[0].text()).toEqual("This is a comment")
      )


