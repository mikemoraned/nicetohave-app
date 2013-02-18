window.nicetohave ?= {}

class Privilege
  constructor: (trello) ->
    @trello = trello
    @level = ko.observable(nicetohave.PrivilegeLevel.NONE)

  using: (expectedLevel, success) ->
    if @level().satisfies(expectedLevel)
      success(@trello)
    else
      console.log("Raising level to")
      console.dir(expectedLevel)
      @raiseTo(expectedLevel, success)

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
    });


window.nicetohave.Privilege = Privilege