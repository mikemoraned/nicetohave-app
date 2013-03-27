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
      console.log("local")
      console.dir(@localComments())
      console.log("remote")
      console.dir(@remoteComments())
      @localComments().concat(@remoteComments())
    )
    @loadStatus = ko.observable("created")

    @hasComments = ko.computed(() =>
      @comments().length > 0
    )

    @editable = ko.computed(() =>
      not (@loadStatus() == 'in-progress' or @loadStatus().indexOf("failed") > 0)
    )

  load: () =>
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

    console.log("#{@id()}: _sendLocalComments, outstanding: #{@outstanding.count()}, local: #{@localComments().length}, remote: #{@remoteComments().length}")

    sendNextLocalComment = () =>
      console.log("#{@id()}: sendNextLocalComment, outstanding: #{@outstanding.count()}, local: #{@localComments().length}, remote: #{@remoteComments().length}")

      comment = @_peek(@localComments())
      @privilege.using(nicetohave.PrivilegeLevel.READ_WRITE, (trello) =>
        @outstanding.started()
        trello.post("/cards/" + @id() + "/actions/comments", { text: comment.text() }, onSuccess, onFailure)
      )

    onSuccess = () =>
      console.log("#{@id()}: onSuccess, outstanding: #{@outstanding.count()}, local: #{@localComments().length}, remote: #{@remoteComments().length}")
      @outstanding.completed()
      console.log("onSuccess")
      console.dir(@localComments())
      completed = @localComments.pop()
      console.log("completed")
      console.dir(completed.text())
      @remoteComments.unshift(completed)
      if @localComments().length == 0
        @loadStatus("saved")
        @load()
        @outstanding.completed()
      else
        sendNextLocalComment()

    onFailure = () =>
      console.log("#{@id()}: onFailure, outstanding: #{@outstanding.count()}, local: #{@localComments().length}, remote: #{@remoteComments().length}")
      @loadStatus("save-failed")

    sendNextLocalComment()

  _peek: (array) =>
    array[array.length - 1]

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