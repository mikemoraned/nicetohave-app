window.nicetohave ?= {}

class Comment

  constructor: (text) ->
    @text = ko.observable(text)

window.nicetohave.Comment = Comment