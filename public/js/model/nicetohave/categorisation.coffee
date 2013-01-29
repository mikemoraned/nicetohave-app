window.nicetohave ?= {}

class Position

  constructor: (@v) ->
    @v = 1.0 if @v > 1.0
    @v = 0.0 if @v < 0.0

  hasValue: () => @v?

  value: () => @v

class Categorisation

  constructor: (card) ->
    @card = card
    @axes = ko.computed(() =>
      axes = { "risk": new Position(), "value": new Position() }
      if (@card.hasComments())
        @_parseComment(@card.latestComment().text(), axes)
      axes
    )

  axis: (name) =>
    position = @axes()[name]
    position

  _parseComment: (text, axes) ->
    re = /(risk|value):([\d.]+)/g
    while (match = re.exec(text))
      axis = match[1]
      value = parseFloat(match[2])
      axes[axis] = new Position(value)
    axes

window.nicetohave.Categorisation = Categorisation