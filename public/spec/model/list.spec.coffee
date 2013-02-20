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
        if (path == '50f5c98fe0314ccd5500a51d')
          successFn(listResponse)
        else
          if (path == '50f5c98fe0314ccd5500a51d/cards')
            successFn(cardsResponse)
      )

    it 'when asked to load, loads name', ->
      privilige = new nicetohave.Privilege(trello)
      privilige.level(nicetohave.PrivilegeLevel.READ_ONLY)

      list = new nicetohave.List("50f5c98fe0314ccd5500a51d", privilige)

      list.load()

      expect(trello.lists.get).toHaveBeenCalled()
      expect(list.name()).toEqual("Doing")

    it 'when asked to load, loads cards with ids', ->
      privilige = new nicetohave.Privilege(trello)
      privilige.level(nicetohave.PrivilegeLevel.READ_ONLY)

      list = new nicetohave.List("50f5c98fe0314ccd5500a51d", privilige)

      list.load()

      expect(trello.lists.get).toHaveBeenCalled()
      expect(list.cards().length).toEqual(3)
      expect(list.cards()[0].id()).toEqual("510557f3e002eb8d56002e04")
      expect(list.cards()[1].id()).toEqual("5105af6108fa2a6e21000dc5")
      expect(list.cards()[2].id()).toEqual("5122b28d00e3df314d005722")

    it 'when asked to load twice, re-use existing card objects for same id', ->
      privilige = new nicetohave.Privilege(trello)
      privilige.level(nicetohave.PrivilegeLevel.READ_ONLY)

      list = new nicetohave.List("50f5c98fe0314ccd5500a51d", privilige)

      list.load()

      expect(trello.lists.get).toHaveBeenCalled()

      expect(list.cards().length).toEqual(3)
      expect(list.cards()[0].id()).toEqual("510557f3e002eb8d56002e04")
      expect(list.cards()[1].id()).toEqual("5105af6108fa2a6e21000dc5")
      expect(list.cards()[2].id()).toEqual("5122b28d00e3df314d005722")

      [card1, card2, card3] = list.cards()

      list.load()

      expect(list.cards().length).toEqual(3)
      expect(list.cards()[0]).toBe(card1)
      expect(list.cards()[1]).toBe(card2)
      expect(list.cards()[2]).toBe(card3)

    listResponse = JSON.parse("""
                              {"id":"50f5c98fe0314ccd5500a51d",
                               "name":"Doing",
                               "closed":false,
                               "idBoard":"50f5c98fe0314ccd5500a51b",
                               "pos":32768}
                              """)

    cardsResponse = JSON.parse("""
                               [
                                   {
                                      "id":"510557f3e002eb8d56002e04",
                                      "badges":{
                                         "votes":0,
                                         "viewingMemberVoted":false,
                                         "subscribed":false,
                                         "fogbugz":"",
                                         "checkItems":0,
                                         "checkItemsChecked":0,
                                         "comments":10,
                                         "attachments":0,
                                         "description":false,
                                         "due":null
                                      },
                                      "checkItemStates":[

                                      ],
                                      "closed":false,
                                      "dateLastActivity":"2013-01-27T21:27:31.963Z",
                                      "desc":"",
                                      "due":null,
                                      "idBoard":"50f5c98fe0314ccd5500a51b",
                                      "idChecklists":[

                                      ],
                                      "idList":"50f5c98fe0314ccd5500a51d",
                                      "idMembers":[

                                      ],
                                      "idMembersVoted":[

                                      ],
                                      "idShort":1,
                                      "idAttachmentCover":null,
                                      "manualCoverAttachment":false,
                                      "labels":[

                                      ],
                                      "name":"Test card",
                                      "pos":65535,
                                      "shortUrl":"https://trello.com/c/MZkgftNb",
                                      "subscribed":false,
                                      "url":"https://trello.com/card/test-card/50f5c98fe0314ccd5500a51b/1"
                                   },
                                   {
                                      "id":"5105af6108fa2a6e21000dc5",
                                      "badges":{
                                         "votes":0,
                                         "viewingMemberVoted":false,
                                         "subscribed":false,
                                         "fogbugz":"",
                                         "checkItems":0,
                                         "checkItemsChecked":0,
                                         "comments":6,
                                         "attachments":0,
                                         "description":false,
                                         "due":null
                                      },
                                      "checkItemStates":[

                                      ],
                                      "closed":false,
                                      "dateLastActivity":"2013-01-29T23:32:37.852Z",
                                      "desc":"",
                                      "due":null,
                                      "idBoard":"50f5c98fe0314ccd5500a51b",
                                      "idChecklists":[

                                      ],
                                      "idList":"50f5c98fe0314ccd5500a51d",
                                      "idMembers":[

                                      ],
                                      "idMembersVoted":[

                                      ],
                                      "idShort":2,
                                      "idAttachmentCover":null,
                                      "manualCoverAttachment":false,
                                      "labels":[

                                      ],
                                      "name":"Another test card with assignments",
                                      "pos":131071,
                                      "shortUrl":"https://trello.com/c/ZtpHkA0R",
                                      "subscribed":false,
                                      "url":"https://trello.com/card/another-test-card-with-assignments/50f5c98fe0314ccd5500a51b/2"
                                   },
                                   {
                                      "id":"5122b28d00e3df314d005722",
                                      "badges":{
                                         "votes":0,
                                         "viewingMemberVoted":false,
                                         "subscribed":false,
                                         "fogbugz":"",
                                         "checkItems":0,
                                         "checkItemsChecked":0,
                                         "comments":3,
                                         "attachments":0,
                                         "description":false,
                                         "due":null
                                      },
                                      "checkItemStates":[

                                      ],
                                      "closed":false,
                                      "dateLastActivity":"2013-02-18T23:03:10.779Z",
                                      "desc":"",
                                      "due":null,
                                      "idBoard":"50f5c98fe0314ccd5500a51b",
                                      "idChecklists":[

                                      ],
                                      "idList":"50f5c98fe0314ccd5500a51d",
                                      "idMembers":[

                                      ],
                                      "idMembersVoted":[

                                      ],
                                      "idShort":3,
                                      "idAttachmentCover":null,
                                      "manualCoverAttachment":false,
                                      "labels":[

                                      ],
                                      "name":"Foop",
                                      "pos":196607,
                                      "shortUrl":"https://trello.com/c/pbhsBB5j",
                                      "subscribed":false,
                                      "url":"https://trello.com/card/foop/50f5c98fe0314ccd5500a51b/3"
                                   }
                               ]
                               """)