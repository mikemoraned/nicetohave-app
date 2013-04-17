window.nicetohave ?= {}

class Navigator

  constructor: () ->
    @idSelected = ko.observable()
    @atBoardId = ko.computed(() => @idSelected()?)

  clear: () =>
    @idSelected(null)

  navigateTo: (id) =>
    if @idSelected() != id
      @idSelected(id)
      window.location = "/app##{id}"

window.nicetohave.Navigator = Navigator