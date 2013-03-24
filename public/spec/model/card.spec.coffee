describe 'Card', ->

  outstanding = null

  beforeEach(() =>
    outstanding = new nicetohave.Outstanding()
  )

  describe 'initial state', ->

    it 'cannot be created without an id', ->
      expect(-> new nicetohave.Card()).toThrow({ message: "Not a valid card id: 'undefined'" })

    it 'must only accept an id of the right format (alphanumeric)', ->
      expect(-> new nicetohave.Card("  csdc  scd")).toThrow({ message: "Not a valid card id: '  csdc  scd'" })

    it 'must only accept an id of the right length (24)', ->
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
          get: (path, params, successFn, errorFn) ->
        }
      }
      spyOn(trello.cards, 'get').andCallFake((path, params, successFn, errorFn) ->
        if (path == '4eea503d91e31d174600008f')
          successFn({ name: "A dummy name"})
        else
          successFn(commentsResponse)
      )

    it 'when asked to load, loads name', ->
      privilege = new nicetohave.Privilege(trello)
      privilege.level(nicetohave.PrivilegeLevel.READ_ONLY)

      card = new nicetohave.Card("4eea503d91e31d174600008f", privilege, outstanding)

      card.load()

      expect(trello.cards.get).toHaveBeenCalled()
      expect(card.name()).toEqual("A dummy name")

    it 'when asked to load, loads comments', ->
      privilege = new nicetohave.Privilege(trello)
      privilege.level(nicetohave.PrivilegeLevel.READ_ONLY)

      card = new nicetohave.Card("4eea503d91e31d174600008f", privilege, outstanding)

      card.load()

      expect(card.comments().length).toEqual(1)
      expect(card.comments()[0].text()).toEqual("This is a comment")

    commentsResponse = JSON.parse("""
                                  [
                                     {
                                        "id":"51059bc37001c216210011b0",
                                        "idMemberCreator":"506b41beead39f966c0ce110",
                                        "data":{
                                           "text":"This is a comment",
                                           "board":{
                                              "name":"NiceToHaveTestBoard",
                                              "id":"50f5c98fe0314ccd5500a51b"
                                           },
                                           "card":{
                                              "name":"Test card",
                                              "idShort":1,
                                              "id":"510557f3e002eb8d56002e04"
                                           },
                                           "dateLastEdited":"2013-01-27T21:52:51.575Z"
                                        },
                                        "type":"commentCard",
                                        "date":"2013-01-27T21:27:31.934Z",
                                        "memberCreator":{
                                           "id":"506b41beead39f966c0ce110",
                                           "avatarHash":null,
                                           "fullName":"Mike Moran",
                                           "initials":"MM",
                                           "username":"lazysurefix"
                                        },
                                        "entities":[
                                           {
                                              "type":"member",
                                              "id":"506b41beead39f966c0ce110",
                                              "text":"Mike Moran"
                                           },
                                           {
                                              "type":"text",
                                              "text":"on",
                                              "idContext":"510557f3e002eb8d56002e04",
                                              "hideIfContext":true
                                           },
                                           {
                                              "type":"card",
                                              "id":"510557f3e002eb8d56002e04",
                                              "text":"Test card",
                                              "hideIfContext":true
                                           },
                                           {
                                              "type":"comment",
                                              "text":"This is a comment",
                                              "textHtml":"This is a comment"
                                           }
                                        ]
                                     }
                                  ]
                                  """)

  describe 'adding comments', ->

    trello = null

    aComment = new nicetohave.Comment("aComment")

    beforeEach ->
      trello = {
        post: (path, params, successFn, errorFn) ->
        cards: {
          get: (path, params, successFn, errorFn) ->
        }
      }
      spyOn(trello.cards, 'get').andCallFake((path, params, successFn, errorFn) ->
        if (path == '4eea503d91e31d174600008f')
          successFn({ name: "A dummy name"})
        else
          if (path == '4eea503d91e31d174600008f/actions' && params.filter == 'commentCard')
            successFn([ { entities: [ { type: 'comment', text: aComment.text() } ] } ] )
          else
            errorFn()
      )

    it 'whilst new comment is being saved, it appears as part of the model', ->
      privilege = new nicetohave.Privilege(trello)
      privilege.level(nicetohave.PrivilegeLevel.READ_WRITE)

      card = new nicetohave.Card("4eea503d91e31d174600008f", privilege, outstanding)

      numCommentsDuringSave = 0
      spyOn(trello, 'post').andCallFake((path, params, successFn, errorFn) ->
        if (path == '/cards/4eea503d91e31d174600008f/actions/comments')
          numCommentsDuringSave = card.comments().length
          successFn()
        else
          errorFn()
      )

      expect(card.comments().length).toEqual(0)
      card.addComment(aComment)
      expect(numCommentsDuringSave).toEqual(1)
      expect(card.comments().length).toEqual(1)

