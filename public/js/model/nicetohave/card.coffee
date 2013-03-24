window.nicetohave ?= {}

class Card

  constructor: (id, privilege, @outstanding) ->
    if not /[a-z0-9]{24}/.test(id)
      throw { message: "Not a valid card id: '#{id}'" }
    @id = ko.observable(id)
    @privilege = privilege
    @name = ko.observable("")
    @comments = ko.observableArray()
    @loadStatus = ko.observable("created")

    @hasComments = ko.computed(() =>
      @comments().length > 0
    )

  load: =>
    @loadStatus("in-progress")
    @outstanding.started()
    onSuccess = (data) =>
      @_parseFields(data)
      @_loadComments()
      @outstanding.completed()
    onFailure = => @loadStatus("load-failed")
    @privilege.using(nicetohave.PrivilegeLevel.READ_ONLY, (trello) =>
      trello.cards.get(@id(), { fields: "name" }, onSuccess, onFailure)
    )

  addComment: (comment) =>
    @outstanding.started()
    onSuccess = () =>
      @loadStatus("saved")
      @load()
      @outstanding.completed()
    onFailure = => @loadStatus("save-failed")
    @privilege.using(nicetohave.PrivilegeLevel.READ_WRITE, (trello) =>
      trello.post("/cards/" + @id() + "/actions/comments", { text: comment.text() }, onSuccess, onFailure)
    )

  _loadComments: =>
    @outstanding.started()
    onSuccess = (data) =>
      @_parseComments(data)
      @loadStatus("loaded")
      @outstanding.completed()
    onFailure = => @loadStatus("load-failed")
    @privilege.using(nicetohave.PrivilegeLevel.READ_ONLY, (trello) =>
      trello.cards.get(@id() + "/actions", { entities: true, filter: "commentCard" }, onSuccess, onFailure)
    )

  _parseFields: (data) =>
    if data == null or typeof data == "undefined"
      console.log("Something wierd happening, ignoring for now")
    else
      @name(data.name)

  _parseComments: (data) =>
    @comments(data.map((d)->
      texts = (e.text for e in d.entities when e.type == 'comment')
      new nicetohave.Comment(texts[0])
    ))

window.nicetohave.Card = Card