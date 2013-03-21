window.nicetohave ?= {}

class Privilege
  constructor: (trello) ->
    @trello = trello
    @level = ko.observable(nicetohave.PrivilegeLevel.NONE)
    @callDepth = ko.observable(0)
#    @callDepth.subscribe((d) -> console.log("Depth: #{d}"))

  using: (expectedLevel, fn) ->
    tracked = (trello) =>
      @callDepth(@callDepth() + 1)
      fn(trello)
      @callDepth(@callDepth() - 1)
    if @level().satisfies(expectedLevel)
      tracked(@trello)
    else
      console.log("Raising level to")
      console.dir(expectedLevel)
      @raiseTo(expectedLevel, tracked)

  raiseTo: (level, success) ->
    @trello.deauthorize()
    @level(nicetohave.PrivilegeLevel.NONE)
    @trello.authorize({
      type: "popup",
      name: "Nice to have",
      success: () =>
        console.log("Success!")
        @level(level)
        success(@trello)
      ,
      error: (m) =>
        console.log("Error: #{m}")
      ,
      scope: level.trelloScope
    })

window.nicetohave.Privilege = Privilege