window.nicetohave ?= {}

class AppViewModel

  constructor: ->
    @privilege = new nicetohave.Privilege(Trello)
    @workingArea = ko.observable(new nicetohave.WorkingArea(@privilege))
    @categoriseView = new nicetohave.D3CategorisationView(600, 600)
    @categoriseView.subscribeTo(@workingArea().categorisations)

window.nicetohave.AppViewModel = AppViewModel