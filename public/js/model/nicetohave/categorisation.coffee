window.nicetohave ?= {}

class Position

  constructor: (v) ->
    @_v = ko.observable(if v? then @clamp(v) else null)
    @value = ko.computed(
      read: @_v
      write: (v) => @_v(@clamp(v))
    )

  hasValue: () => @_v()?

  clamp: (v) ->
    Math.min(1.0, Math.max(0.0, v))

  toString: () =>
    if @hasValue()
      @value().toString()
    else
      "unknown"

class Categorisation

  constructor: (card) ->
    @card = card
    @_axes = ko.computed(() =>
      axes = { "risk": new Position(), "value": new Position() }
      if (@card.hasComments())
        for comment in @card.comments()
          if @_parseComment(comment.text(), axes)
            break
      axes
    )
    @axes = ko.computed(() =>
      [
        { name: "risk", position: @_axes()["risk"] },
        { name: "value", position: @_axes()["value"] },
      ]
    )

  axis: (name) => @_axes()[name]

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