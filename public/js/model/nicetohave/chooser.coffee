window.nicetohave ?= {}

class Chooser

  constructor: (@navigator) ->
    @boardUrl = ko.observable()
    @boardId = ko.computed(() =>
      @_parseBoardUrl(@boardUrl())
    )
    @navigable = ko.computed(() =>
      @boardId()?
    )

  navigateTo: () =>
    if @navigable()?
      @navigator.navigateTo(@boardId())

  _parseBoardUrl : (url) =>
    boardPattern = /\s*https:\/\/trello.com\/board\/.+?\/([a-z0-9]+)\s*/
    if url?
      match = url.match(boardPattern)
      if match?
        match[1]
      else
        null
    else
      null

window.nicetohave.Chooser = Chooser