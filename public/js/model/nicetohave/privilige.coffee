window.nicetohave ?= {}

class Privilege
  @READ_ONLY : {
    name: "read",
    trelloScope : {
      read: true,
      write: false
    }
  }
  @READ_WRITE : {
    name: "read-write",
    trelloScope: {
      read: true,
      write: true
    }
  }

window.nicetohave.Privilege = Privilege