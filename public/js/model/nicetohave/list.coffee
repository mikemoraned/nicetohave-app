window.nicetohave ?= {}

class List

  constructor: (id, privilege) ->
    if not /[a-z0-9]{24}/.test(id)
      throw { message: "Not a valid list id: '#{id}'" }
    @id = ko.observable(id)
    @privilege = privilege
    @loadStatus = ko.observable("created")

    @name = ko.observable("")
    @cards = ko.observableArray()

  load: () =>
    @loadStatus("in-progress")
    onSuccess =
    onFailure = => @loadStatus("load-failed")
    @privilege.using(nicetohave.PrivilegeLevel.READ_ONLY, (trello) =>
      trello.lists.get(@id(),
        (data) =>
          @_parseFields(data)
          trello.lists.get(@id() + "/cards", ((data) => @_parseCards(data)), onFailure)
        ,
        onFailure)
    )

  _parseFields: (data) =>
    @name(data.name)

  _parseCards: (data) =>
    console.dir(data)
    @cards(@_getCard(c.id) for c in data)

  _getCard: (id) =>
    new nicetohave.Card(id, @privilege)

window.nicetohave.List = List