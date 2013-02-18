window.nicetohave ?= {}

class AppViewModel

  constructor: ->
    @privilege = new nicetohave.Privilege(Trello)
    @workingArea = ko.observable(new nicetohave.WorkingArea(@privilege))

window.nicetohave.AppViewModel = AppViewModel