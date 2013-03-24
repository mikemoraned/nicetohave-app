window.nicetohave ?= {}

class Card

  constructor: (id, privilege, @outstanding) ->
    if not /[a-z0-9]{24}/.test(id)
      throw { message: "Not a valid card id: '#{id}'" }
    @id = ko.observable(id)
    @privilege = privilege
    @name = ko.observable("")
    @localComments = ko.observableArray()
    @remoteComments = ko.observableArray()
    @comments = ko.computed(() =>
      @localComments().concat(@remoteComments())
    )
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
    @localComments.unshift(comment)
    @_sendLocalComments()

  _sendLocalComments: () =>
    @outstanding.started()

    sendNextLocalComment = () =>
      @outstanding.started()
      comment = @_peek(@localComments)
      @privilege.using(nicetohave.PrivilegeLevel.READ_WRITE, (trello) =>
        trello.post("/cards/" + @id() + "/actions/comments", { text: comment.text() }, onSuccess, onFailure)
      )

    onSuccess = () =>
      @localComments.pop()
      @outstanding.completed()
      if @localComments().length == 0
        @loadStatus("saved")
        @load()
        @outstanding.completed()
      else
        sendNextLocalComment()

    onFailure = => @loadStatus("save-failed")

    sendNextLocalComment()

  _peek: (array) =>
    val = array.pop()
    array.push(val)
    val

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
    @remoteComments(data.map((d)->
      texts = (e.text for e in d.entities when e.type == 'comment')
      new nicetohave.Comment(texts[0])
    ))

window.nicetohave.Card = Card