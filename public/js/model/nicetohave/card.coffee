window.nicetohave ?= {}

class Card

  constructor: (id, privilege) ->
    if not /[a-z0-9]{24}/.test(id)
      throw { message: "Not a valid card id: '#{id}'" }
    @id = ko.observable(id)
    @privilege = privilege

  name : ko.observable("")
  loadStatus: ko.observable("created")

  load: ->
    @loadStatus("in-progress")
    onSuccess = (data) =>
      @parseFromTrello(data)
      @loadStatus("loaded")
    onFailure = => @loadStatus("load-failed")
    @privilege.using(nicetohave.PrivilegeLevel.READ_ONLY, (trello) =>
      trello.cards.get(@id(), { fields: "name" }, onSuccess, onFailure)
    )

  parseFromTrello: (data) ->
    @name(data.name)

window.nicetohave.Card = Card