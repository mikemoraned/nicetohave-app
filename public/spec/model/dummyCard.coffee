window.nicetohave ?= {}

class DummyCard
  constructor: (id) ->
    @name = ko.observable("A Dummy Card")
    @comments = ko.observableArray()
    @id = ko.observable(id)
    @editable = ko.observable(true)

  addComment: (comment) =>
    @comments.unshift(comment)

window.nicetohave.DummyCard = DummyCard