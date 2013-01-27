window.nicetohave ?= {}

class PrivilegeLevel
  @NONE : {
    name: "none",
    trelloScope : {
      read: false,
      write: false
    },
    satisfies: (otherLevel) -> !otherLevel.trelloScope.read && !otherLevel.trelloScope.write
  }
  @READ_ONLY : {
    name: "read",
    trelloScope : {
      read: true,
      write: false
    },
    satisfies: (otherLevel) -> !otherLevel.trelloScope.write
  }
  @READ_WRITE : {
    name: "read-write",
    trelloScope: {
      read: true,
      write: true
    },
    satisfies: (otherLevel) -> true
  }

window.nicetohave.PrivilegeLevel = PrivilegeLevel