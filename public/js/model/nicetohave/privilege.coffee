window.nicetohave ?= {}

class Privilege
  level : ko.observable(nicetohave.PrivilegeLevel.READ_ONLY)

  constructor: (trello) -> @trello = trello

  using: (expectedLevel, success) ->
    if @level().satisfies(expectedLevel)
      success(Trello)
    else
      @raiseTo(expectedLevel, success)

  raiseTo: (level, success) ->
    @trello.authorize({
      type: "popup",
      name: "Nice to have",
      success: =>
        @level(level)
        success(@trello)
      ,
      error: (m) =>
        console.log("Error: #{m}")
      ,
      scope: level.trelloScope
    });


window.nicetohave.Privilege = Privilege