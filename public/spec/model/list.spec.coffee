describe 'List', ->

  describe 'initial state', ->

    it 'cannot be created without an id', ->
      expect(-> new nicetohave.List()).toThrow({ message: "Not a valid list id: 'undefined'" })

    it 'must only accept an id of the right format (alphanumeric)', ->
      expect(-> new nicetohave.List("  csdc  scd")).toThrow({ message: "Not a valid list id: '  csdc  scd'" })

    it 'must only accept an id of the right length (24)', ->
      expect(-> new nicetohave.List("4eea503d91e31d174600")).toThrow({ message: "Not a valid list id: '4eea503d91e31d174600'" })

    it 'has an empty name', ->
      list = new nicetohave.List("4eea503d91e31d174600008f")
      expect(list.name()).toBe ""

    it 'has an id', ->
      list = new nicetohave.List("4eea503d91e31d174600008f")
      expect(list.id()).toBe "4eea503d91e31d174600008f"

    it 'has a created load status', ->
      list = new nicetohave.List("4eea503d91e31d174600008f")
      expect(list.loadStatus()).toBe "created"

  describe 'loading', ->

    trello = null

    beforeEach ->
      trello = {
        lists: {
          get: (path, params, successFn, errorFn) ->
        }
      }
      spyOn(trello.lists, 'get').andCallFake((path, params, successFn, errorFn) ->
        if (path == '4eea503d91e31d174600008f')
          successFn({ name: "A dummy name"})
        else
          successFn(commentsResponse)
      )

    it 'when asked to load, loads name', ->
      privilige = new nicetohave.Privilege(trello)
      privilige.level(nicetohave.PrivilegeLevel.READ_ONLY)

      list = new nicetohave.List("4eea503d91e31d174600008f", privilige)

      list.load()

      expect(trello.lists.get).toHaveBeenCalled()
      expect(list.name()).toEqual("A dummy name")

    it 'when asked to load, loads cards', ->
      privilige = new nicetohave.Privilege(trello)
      privilige.level(nicetohave.PrivilegeLevel.READ_ONLY)

      list = new nicetohave.List("4eea503d91e31d174600008f", privilige)

      list.load()

      expect(list.cards().length).toEqual(1)