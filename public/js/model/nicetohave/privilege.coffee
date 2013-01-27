window.nicetohave ?= {}

class Privilege
  constructor: (trello) ->
    @trello = trello
    @level = ko.observable(nicetohave.PrivilegeLevel.NONE)

  using: (expectedLevel, success) ->
    if @level().satisfies(expectedLevel)
      success(@trello)
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