window.nicetohave ?= {}

class PrivilegeLevel
  @READ_ONLY : {
    name: "read",
    trelloScope : {
      read: true,
      write: false
    },
    satisfies: (otherLevel) ->
      otherLevel.read
  }
  @READ_WRITE : {
    name: "read-write",
    trelloScope: {
      read: true,
      write: true
    },
    satisfies: (otherLevel) ->
      otherLevel.read && otherLevel.write
  }

window.nicetohave.PrivilegeLevel = PrivilegeLevel