window.nicetohave ?= {}

class User
  privileges : ko.observable(nicetohave.Privilege.READ_ONLY)

  using: (expectedPrivileges, success) ->
    if @privileges() == expectedPrivileges
      success(Trello)
    else
      @raiseTo(expectedPrivileges, success)

  raiseTo: (expectedPrivileges, success) ->
    Trello.authorize({
      type: "popup",
      name: "Nice to have",
      success: =>
        @privileges(expectedPrivileges); success(Trello)
      ,
      error: => ,
      scope: expectedPrivileges.trelloScope
    });


window.nicetohave.User = User