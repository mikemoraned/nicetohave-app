window.nicetohave ?= {}

class Position

  constructor: (v) ->
    @_v = ko.observable(if v? then @normalize(v) else null)

  hasValue: () => @value()?

  clamp: (v) ->
    Math.min(1.0, Math.max(0.0, v))

  normalize: (v) ->
    parseFloat(@clamp(v).toFixed(3))


class CommentPosition extends Position

  constructor: (v) ->
    super v
    @value = ko.computed(
      read: @_v
      write: (v) =>
        if v?
          @_v(@normalize(v))
        else
          @_v(null)
    )

class EditablePosition extends Position

  constructor: (commentPos) ->
    super null
    @value = ko.computed(
      read: () =>
        if @_v()?
          @_v()
        else
          commentPos.value()
      write: (v) =>
        if v?
          @_v(@normalize(v))
        else
          @_v(null)
    )
    @hasEdits = ko.computed(() =>
      console.log("my: #{@value()}, comment: #{commentPos.value()}")
      @value() != commentPos.value()
    )

  discardEdits: () =>
    @_v(null)

class Categorisation

  constructor: (card) ->
    @card = card

    @commentRisk = new CommentPosition()
    @commentValue = new CommentPosition()

    @editableRisk = new EditablePosition(@commentRisk)
    @editableValue = new EditablePosition(@commentValue)

    @_updateCommentValues(@card.comments())
    @card.comments.subscribe(@_updateCommentValues)

    @axes = ko.computed(() =>
      [
        { name: "risk", position: @editableRisk },
        { name: "value", position: @editableValue },
      ]
    )

    @hasEdits = ko.computed(() =>
      @editableRisk.hasEdits() || @editableValue.hasEdits()
    )

  fullyDefined: () =>
    @editableRisk.hasValue() && @editableRisk.hasValue()

  axis: (name) =>
    if name == "risk"
      @editableRisk
    else if name == "value"
      @editableValue
    else
      null

  discardEdits: () =>
    if @hasEdits()
      @editableRisk.discardEdits()
      @editableValue.discardEdits()

  saveEdits: () =>
    if @hasEdits()
      formatted = []
      if @editableRisk.hasEdits()
        formatted.push("risk:#{@editableRisk.value()}")
      if @editableValue.hasEdits()
        formatted.push("value:#{@editableValue.value()}")
      @card.addComment(new nicetohave.Comment(formatted.join(" ")))

      @editableRisk.discardEdits()
      @editableValue.discardEdits()

  _updateCommentValues: (comments) =>
    console.log("Updating based on comments for #{@card.name()}")
    console.dir(comments)
    foundValue = { "risk" : false, "value" : false }
    axes = { "risk": @commentRisk, "value": @commentValue }
    for comment in comments
      @_parseComment(comment.text(), axes, foundValue)
    for name in ["risk","value"]
      if !foundValue[name]
        axes[name].value(null)

  _parseComment: (text, axes, foundValue) ->
    re = /(risk|value):([\d.]+)/g
    while (match = re.exec(text))
      axis = match[1]
      if not foundValue[axis]
        axes[axis].value(parseFloat(match[2]))
        foundValue[axis] = true

window.nicetohave.Categorisation = Categorisation