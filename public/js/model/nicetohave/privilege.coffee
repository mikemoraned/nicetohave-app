window.nicetohave ?= {}

class Privilege
  constructor: (trello) ->
    @trello = trello
    @level = ko.observable(nicetohave.PrivilegeLevel.NONE)
    @changingLevel = ko.observable(false)
    @callDepth = ko.observable(0)
#    @callDepth.subscribe((d) -> console.log("Depth: #{d}"))
    @pendingSuccessFnForLevel = {}

  using: (expectedLevel, fn) =>
    tracked = (trello) =>
      @callDepth(@callDepth() + 1)
      fn(trello)
      @callDepth(@callDepth() - 1)
    if @level().satisfies(expectedLevel)
      tracked(@trello)
    else
      if @pendingSuccessFnForLevel[expectedLevel.name]?
        console.log("Already a pending raise to level #{expectedLevel.name}, will join that one")
        @pendingSuccessFnForLevel[expectedLevel.name].push(tracked)
      else
        console.log("Raising level to #{expectedLevel.name}")
        @pendingSuccessFnForLevel[expectedLevel.name] = [tracked]
        @_raiseTo(expectedLevel)

  _raiseTo: (level) =>
    @changingLevel(true)
    @trello.deauthorize()
    @level(nicetohave.PrivilegeLevel.NONE)
    @trello.authorize({
      type: "popup",
      name: "Nice to have",
      success: () =>
        console.log("Success!")
        @level(level)
        @changingLevel(false)
        successFns = @pendingSuccessFnForLevel[level.name]
        console.log("Calling back #{successFns.length} successFns")
        for pendingSuccessFn in successFns
          pendingSuccessFn(@trello)
        @pendingSuccessFnForLevel[level.name] = null
      ,
      error: (m) =>
        @pendingSuccessFnForLevel[level.name] = null
        @changingLevel(false)
        console.log("Error: #{m}")
      ,
      scope: level.trelloScope
    })

window.nicetohave.Privilege = Privilege