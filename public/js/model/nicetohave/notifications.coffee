window.nicetohave ?= {}

class Notifications
  constructor: (@privilege) ->
    @levelWentAboveNone = ko.observable(false)
    @privilege.level.subscribe((l) =>
      if l != nicetohave.PrivilegeLevel.NONE
        @levelWentAboveNone(true)
    )
    @alerts = ko.computed(() =>
      if @privilege.changingLevel() and not @levelWentAboveNone()
        [{ title: "Note", message: "For this application to work, you will need to allow it to raise pop-ups "}]
      else
        []
    )

window.nicetohave.Notifications = Notifications