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
        [{ type: 'popupWarning', title: "Note" }]
      else
        []
    )

  templateName: (alert) -> "#{alert.type}Template"

window.nicetohave.Notifications = Notifications