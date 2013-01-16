window.nicetohave ?= {}

class Privilige
  @READ_ONLY : "read"
  @READ_WRITE : "read-write"

class User
  priviliges : ko.observable(Privilige.READ_ONLY)

window.nicetohave.User = User