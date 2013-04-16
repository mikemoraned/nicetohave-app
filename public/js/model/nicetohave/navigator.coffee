window.nicetohave ?= {}

class Navigator

  constructor: () ->
    @idSelected = ko.observable()

  navigateTo: (id) =>
    if @idSelected() != id
      @idSelected(id)
      window.location = "/app##{id}"

window.nicetohave.Navigator = Navigator