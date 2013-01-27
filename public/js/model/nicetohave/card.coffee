window.nicetohave ?= {}

class Card

  constructor: (id, privilege) ->
    if not /[a-z0-9]{24}/.test(id)
      throw { message: "Not a valid card id: '#{id}'" }
    @id = ko.observable(id)
    @privilege = privilege

  name : ko.observable("")
  comments : ko.observableArray()
  loadStatus: ko.observable("created")

  load: ->
    @loadStatus("in-progress")
    onSuccess = (data) =>
      @_parseFields(data)
      @_loadComments()
    onFailure = => @loadStatus("load-failed")
    @privilege.using(nicetohave.PrivilegeLevel.READ_ONLY, (trello) =>
      trello.cards.get(@id(), { fields: "name" }, onSuccess, onFailure)
    )

  _loadComments: ->
    onSuccess = (data) =>
      @_parseComments(data)
      @loadStatus("loaded")
    onFailure = => @loadStatus("load-failed")
    @privilege.using(nicetohave.PrivilegeLevel.READ_ONLY, (trello) =>
      trello.cards.get(@id() + "/actions", { entities: true, filter: "commentCard" }, onSuccess, onFailure)
    )

  _parseFields: (data) ->
    @name(data.name)

  _parseComments: (data) ->
    @comments(data.map((d)->
      texts = (e.text for e in d.entities when e.type == 'comment')
      new nicetohave.Comment(texts[0])
    ))

window.nicetohave.Card = Card