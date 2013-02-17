window.nicetohave ?= {}

class Position

  constructor: (v) ->
    @_v = ko.observable(if v? then @clamp(v) else null)

  hasValue: () => @value()?

  clamp: (v) ->
    Math.min(1.0, Math.max(0.0, v))


class CommentPosition extends Position

  constructor: (v) ->
    super v
    @value = ko.computed(
      read: @_v
      write: (v) =>
        @_v(@clamp(v))
    )
    console.log("Created CommentPosition: #{@value()}")


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
        @_v(@clamp(v))
    )
    @hasEdits = ko.computed(() => @value() != commentPos.value())
    console.log("Created EditablePosition: #{@value()}")

class Categorisation

  constructor: (card) ->
    @card = card

    @commentRisk = new CommentPosition()
    @commentValue = new CommentPosition()

    @editableRisk = new EditablePosition(@commentRisk)
    @editableValue = new EditablePosition(@commentValue)

    @updateCommentValues(@card.comments())
    @card.comments.subscribe(@updateCommentValues)

    @axes = ko.computed(() =>
      [
        { name: "risk", position: @editableRisk },
        { name: "value", position: @editableValue },
      ]
    )

  updateCommentValues: (comments) =>
    console.log("Updating values")
    console.dir(comments)
    axes = { "risk": @commentRisk, "value": @commentValue }
    for comment in comments
      if @_parseComment(comment.text(), axes)
        break

  axis: (name) =>
    if name == "risk"
      console.log("risk: #{@editableRisk.value()}")
      @editableRisk
    else if name == "value"
      console.log("value: #{@editableValue.value()}")
      @editableValue
    else
      null

  _parseComment: (text, axes) ->
    re = /(risk|value):([\d.]+)/g
    matched = false
    while (match = re.exec(text))
      matched = true
      axis = match[1]
      axes[axis].value(parseFloat(match[2]))
    matched

window.nicetohave.Categorisation = Categorisation