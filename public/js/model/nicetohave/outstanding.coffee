window.nicetohave ?= {}

class Outstanding

  constructor: () ->
    @count = ko.observable(0)
#    @count.subscribe((c) -> console.log("Count: #{c}"))

  reset: () =>
    @count(0)

  started: (s) =>
    inc = if s? then s else 1
    if inc <= 0
      throw { message: "Started is not >= 0: #{inc}" }
    curr = @count()
    next = @count() + inc
    @count(next)

  completed: (c) =>
    dec = if c? then c else 1
    if dec <= 0
      throw { message: "Completed is not >= 0: #{dec}" }
    curr = @count()
    next = @count() - dec
    if dec > curr
      throw { message: "Completed is more than outstanding: #{dec} > #{curr}"}
    @count(next)

window.nicetohave.Outstanding = Outstanding