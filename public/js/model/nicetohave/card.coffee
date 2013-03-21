window.nicetohave ?= {}

class Card

  constructor: (id, privilege) ->
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
    onSuccess = (data) =>
      @_parseFields(data)
      @_loadComments()
    onFailure = => @loadStatus("load-failed")
    @privilege.using(nicetohave.PrivilegeLevel.READ_ONLY, (trello) =>
      trello.cards.get(@id(), { fields: "name" }, onSuccess, onFailure)
    )

  addComment: (comment) =>
    onSuccess = () =>
      @loadStatus("saved")
      @load()
    onFailure = => @loadStatus("save-failed")
    @privilege.using(nicetohave.PrivilegeLevel.READ_WRITE, (trello) =>
      trello.post("/cards/" + @id() + "/actions/comments", { text: comment.text() }, onSuccess, onFailure)
    )

  _loadComments: =>
    onSuccess = (data) =>
      @_parseComments(data)
      @loadStatus("loaded")
    onFailure = => @loadStatus("load-failed")
    @privilege.using(nicetohave.PrivilegeLevel.READ_ONLY, (trello) =>
      trello.cards.get(@id() + "/actions", { entities: true, filter: "commentCard" }, onSuccess, onFailure)
    )

  _parseFields: (data) =>
    if not data?
      console.log("Something wierd happening, stop on debugger")
      debugger
    @name(data.name)

  _parseComments: (data) =>
#    console.log("name: #{@name()}:")
#    console.dir(data)
    @comments(data.map((d)->
      texts = (e.text for e in d.entities when e.type == 'comment')
      new nicetohave.Comment(texts[0])
    ))

window.nicetohave.Card = Card