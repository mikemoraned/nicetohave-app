window.nicetohave ?= {}

class Board

  constructor: (id, privilege, outstanding) ->
    if not (id? and (/^[a-z0-9]{24}$/.test(id) or /^[a-zA-Z0-9]{8}$/.test(id)))
      throw { message: "Not a valid board id: '#{id}'" }
    @id = ko.observable(id)
    @privilege = privilege
    @outstanding = outstanding
    @loadStatus = ko.observable("created")

    @_existingLists = {}

    @name = ko.observable("")
    @lists = ko.observableArray()

  load: (onSuccessFn) =>
    @outstanding.started()
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
          if onSuccessFn?
            onSuccessFn(this)
          @outstanding.completed()
        , onFailure)
      , onFailure)
    )

  _parseFields: (data) =>
    @name(data.name)

  _parseLists: (data) =>
    @lists(@_getList(c.id) for c in data)

  _loadAllLists: =>
    if @lists().length > 0
      @outstanding.started(@lists().length)
      for list in @lists()
        list.load()
        @outstanding.completed()

  _getList: (id) =>
    if not @_existingLists[id]?
      @_existingLists[id] = new nicetohave.List(id, @privilege, @outstanding)
    @_existingLists[id]

window.nicetohave.Board = Board