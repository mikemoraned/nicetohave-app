window.nicetohave ?= {}
window.nicetohave.trello ?= {}

class Snitch
  constructor: (@callback) ->



class Wrapped

  constructor: (@trello) ->

  get: (path, hash, success, failure) =>

    snitchFn = (arg) =>
      if not arg
        console.log("get: #{path},#{hash}: callback arg is null!")
      if typeof arg == "undefined"
        console.log("get: #{path},#{hash}: callback arg is not defined!")
      success(arg)

    @trello.get(path, hash, snitchFn, failure)

class TrelloQueue

  constructor: (@trello) ->
    @boards = new Wrapped(@trello.boards)
    @lists = new Wrapped(@trello.lists)
    @cards = new Wrapped(@trello.cards)

  authorize: (arg) => @trello.authorize(arg)

  deauthorize: () => @trello.deauthorize()

  post: (path, hash, success, failure) =>

    snitchFn = (arg) =>
      if not arg
        console.log("post: #{path},#{hash}: callback arg is null!")
      if typeof arg == "undefined"
        console.log("post: #{path},#{hash}: callback arg is not defined!")
      success(arg)

    @trello.post(path, hash, snitchFn, failure)

window.nicetohave.trello.TrelloQueue = TrelloQueue