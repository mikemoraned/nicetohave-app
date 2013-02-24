window.nicetohave ?= {}

class List

  constructor: (id, privilege) ->
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
    for card in @cards()
      card.load()

  _getCard: (id) =>
    if not @_existingCards[id]?
      @_existingCards[id] = new nicetohave.Card(id, @privilege)
    @_existingCards[id]

window.nicetohave.List = List