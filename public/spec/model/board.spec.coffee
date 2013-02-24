describe 'Board', ->

  describe 'initial state', ->

    it 'cannot be created without an id', ->
      expect(-> new nicetohave.Board()).toThrow({ message: "Not a valid board id: 'undefined'" })

    it 'must only accept an id of the right format (alphanumeric)', ->
      expect(-> new nicetohave.Board("  csdc  scd")).toThrow({ message: "Not a valid board id: '  csdc  scd'" })

    it 'must only accept an id of the right length (24)', ->
      expect(-> new nicetohave.Board("4eea503d91e31d174600")).toThrow({ message: "Not a valid board id: '4eea503d91e31d174600'" })

    it 'has an empty name', ->
      board = new nicetohave.Board("4eea503d91e31d174600008f")
      expect(board.name()).toBe ""

    it 'has an id', ->
      board = new nicetohave.Board("4eea503d91e31d174600008f")
      expect(board.id()).toBe "4eea503d91e31d174600008f"

    it 'has a created load status', ->
      board = new nicetohave.Board("4eea503d91e31d174600008f")
      expect(board.loadStatus()).toBe "created"

  describe 'loading', ->

    trello = null

    beforeEach ->
      trello = {
        boards: {
          get: (path, params, successFn, errorFn) ->
        }
      }
      spyOn(trello.boards, 'get').andCallFake((path, params, successFn, errorFn) ->
        if (path == '50f5c98fe0314ccd5500a51b')
          successFn(boardResponse)
        else
          if (path == '50f5c98fe0314ccd5500a51b/lists')
            successFn(boardsResponse)
      )

      spyOn(nicetohave.List.prototype, "load")

    it 'when asked to load, loads name', ->
      privilige = new nicetohave.Privilege(trello)
      privilige.level(nicetohave.PrivilegeLevel.READ_ONLY)

      board = new nicetohave.Board("50f5c98fe0314ccd5500a51b", privilige)

      board.load()

      expect(trello.boards.get).toHaveBeenCalled()
      expect(board.name()).toEqual("NiceToHaveTestBoard")

    it 'when asked to load, loads lists with ids', ->
      privilige = new nicetohave.Privilege(trello)
      privilige.level(nicetohave.PrivilegeLevel.READ_ONLY)

      board = new nicetohave.Board("50f5c98fe0314ccd5500a51b", privilige)

      expect(board.loadStatus()).toEqual("created")
      
      board.load()

      expect(board.loadStatus()).toEqual("load-success")

      expect(trello.boards.get).toHaveBeenCalled()
      expect(board.lists().length).toEqual(3)
      expect(board.lists()[0].id()).toEqual("50f5c98fe0314ccd5500a51c")
      expect(board.lists()[1].id()).toEqual("50f5c98fe0314ccd5500a51d")
      expect(board.lists()[2].id()).toEqual("50f5c98fe0314ccd5500a51e")

    it 'when asked to load twice, re-use existing list objects for same id', ->
      privilige = new nicetohave.Privilege(trello)
      privilige.level(nicetohave.PrivilegeLevel.READ_ONLY)

      board = new nicetohave.Board("50f5c98fe0314ccd5500a51b", privilige)

      expect(board.loadStatus()).toEqual("created")

      board.load()

      expect(board.loadStatus()).toEqual("load-success")

      expect(trello.boards.get).toHaveBeenCalled()

      expect(board.lists().length).toEqual(3)
      expect(board.lists()[0].id()).toEqual("50f5c98fe0314ccd5500a51c")
      expect(board.lists()[1].id()).toEqual("50f5c98fe0314ccd5500a51d")
      expect(board.lists()[2].id()).toEqual("50f5c98fe0314ccd5500a51e")

      [list1, list2, list3] = board.lists()

      board.load()

      expect(board.lists().length).toEqual(3)
      expect(board.lists()[0]).toBe(list1)
      expect(board.lists()[1]).toBe(list2)
      expect(board.lists()[2]).toBe(list3)

    boardResponse = JSON.parse("""
                               {"id":"50f5c98fe0314ccd5500a51b","name":"NiceToHaveTestBoard","desc":"","closed":false,"idOrganization":null,"pinned":true,"url":"https://trello.com/board/nicetohavetestboard/50f5c98fe0314ccd5500a51b","prefs":{"permissionLevel":"private","voting":"members","comments":"members","invitations":"members","selfJoin":false,"listCovers":true},"labelNames":{"red":"","orange":"","yellow":"","green":"","blue":"","purple":""}}
                               """)

    boardsResponse = JSON.parse("""
                               [{"id":"50f5c98fe0314ccd5500a51c","name":"To Do","closed":false,"idBoard":"50f5c98fe0314ccd5500a51b","pos":16384,"subscribed":false},{"id":"50f5c98fe0314ccd5500a51d","name":"Doing","closed":false,"idBoard":"50f5c98fe0314ccd5500a51b","pos":32768,"subscribed":false},{"id":"50f5c98fe0314ccd5500a51e","name":"Done","closed":false,"idBoard":"50f5c98fe0314ccd5500a51b","pos":49152,"subscribed":false}]
                               """)