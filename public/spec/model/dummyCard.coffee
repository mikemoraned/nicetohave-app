window.nicetohave ?= {}

class DummyCard
  constructor: (id) ->
    @comments = ko.observableArray()
    @id = ko.observable(id)

  addComment: (comment) =>
    @comments.unshift(comment)

window.nicetohave.DummyCard = DummyCard