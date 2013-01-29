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
        for comment in @card.comments()
          if @_parseComment(comment.text(), axes)
            break
      axes
    )

  axis: (name) =>
    position = @axes()[name]
    position

  _parseComment: (text, axes) ->
    re = /(risk|value):([\d.]+)/g
    matched = false
    while (match = re.exec(text))
      matched = true
      axis = match[1]
      value = parseFloat(match[2])
      axes[axis] = new Position(value)
    matched

window.nicetohave.Categorisation = Categorisation