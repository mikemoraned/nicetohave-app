window.nicetohave ?= {}

class Board

  constructor: (id, privilege) ->
    if not /[a-z0-9]{24}/.test(id)
      throw { message: "Not a valid board id: '#{id}'" }
    @id = ko.observable(id)
    @privilege = privilege
    @loadStatus = ko.observable("created")

    @_existingLists = {}

    @name = ko.observable("")
    @lists = ko.observableArray()

  load: =>
    @loadStatus("in-progress")
    onFailure = => @loadStatus("load-failed")
    @privilege.using(nicetohave.PrivilegeLevel.READ_ONLY, (trello) =>
      trello.boards.get(@id(), {},
      (data) =>
        @_parseFields(data)
        trello.boards.get(@id() + "/lists", {},
        (data) =>
          @_parseLists(data)
          @_loadAllLists()
          @loadStatus("load-success")
        , onFailure)
      , onFailure)
    )

  _parseFields: (data) =>
    @name(data.name)

  _parseLists: (data) =>
    @lists(@_getList(c.id) for c in data)

  _loadAllLists: =>
    for list in @lists()
      list.load()

  _getList: (id) =>
    if not @_existingLists[id]?
      @_existingLists[id] = new nicetohave.List(id, @privilege)
    @_existingLists[id]

window.nicetohave.Board = Board