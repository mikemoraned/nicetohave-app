window.nicetohave ?= {}

class List

  constructor: (id, privilege, @outstanding) ->
    if not /[a-z0-9]{24}/.test(id)
      throw { message: "Not a valid list id: '#{id}'" }
    @id = ko.observable(id)
    @privilege = privilege
    @loadStatus = ko.observable("created")

    @_existingCards = {}

    @name = ko.observable("")
    @cards = ko.observableArray()

  load: () =>
    @loadStatus("in-progress")
    @outstanding.started()
    onFailure = => @loadStatus("load-failed")
    @privilege.using(nicetohave.PrivilegeLevel.READ_ONLY, (trello) =>
      trello.lists.get(@id(), {},
        (data) =>
          @_parseFields(data)
          trello.lists.get(@id() + "/cards", {},
          (data) =>
            @_parseCards(data)
            @_loadAllCards()
            @loadStatus("load-success")
            @outstanding.completed()
          , onFailure)
        , onFailure)
    )

  _parseFields: (data) =>
    if data?
      @name(data.name)
    else
      console.log("Workaround for list data being undefined and then later defined, https://trello.com/c/k2VKLuJg")

  _parseCards: (data) =>
    @cards(@_getCard(c.id) for c in data)

  _loadAllCards: =>
    if @cards().length > 0
      @outstanding.started(@cards().length)
      for card in @cards()
        card.load()
        @outstanding.completed()

  _getCard: (id) =>
    if not @_existingCards[id]?
      @_existingCards[id] = new nicetohave.Card(id, @privilege, @outstanding)
    @_existingCards[id]

window.nicetohave.List = List