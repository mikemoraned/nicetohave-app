describe 'Privilege', ->

  describe 'initial state', ->

    it 'starts off with no priviliges', ->
      expect(new nicetohave.Privilege().level()).toEqual(nicetohave.PrivilegeLevel.NONE)

  describe 'authorization', ->

    trello = null

    beforeEach ->
      trello = {
        authorize: (opts) ->
      }

    it 'when needs to go from none to read-only, asks for authorization', ->
      privilige = new nicetohave.Privilege(trello)

      spyOn(trello, 'authorize').andCallFake((opts) -> opts.success())

      privilige.using(nicetohave.PrivilegeLevel.READ_ONLY, (trello) -> )

      expect(trello.authorize).toHaveBeenCalled()
      expect(privilige.level()).toEqual(nicetohave.PrivilegeLevel.READ_ONLY)

    it 'when already at required privilige level, then does not ask for authorization', ->
      privilige = new nicetohave.Privilege(trello)
      privilige.level(nicetohave.PrivilegeLevel.READ_ONLY)

      spyOn(trello, 'authorize')

      privilige.using(nicetohave.PrivilegeLevel.READ_ONLY, (trello) -> )

      expect(trello.authorize).not.toHaveBeenCalled()
      expect(privilige.level()).toEqual(nicetohave.PrivilegeLevel.READ_ONLY)
