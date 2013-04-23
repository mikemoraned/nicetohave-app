window.nicetohave ?= {}

class AppViewModel

  constructor: ->
    @trello = new nicetohave.trello.TrelloQueue(Trello)
    @privilege = new nicetohave.Privilege(@trello)
    @notifications = new nicetohave.Notifications(@privilege)
    @outstanding = new nicetohave.Outstanding()
    @workingArea = ko.observable()
    @categoriseView = new nicetohave.D3CategorisationView(@outstanding, "svg", 1200, 600)
    @navigator = new nicetohave.Navigator()
    @chooser = new nicetohave.Chooser(@navigator)

  run: =>
    Sammy((sammy) =>
      sammy.get('#:boardId', (context) =>
        @_switchToBoard(context.params.boardId)
      )
      sammy.notFound = (context) =>
        @_reset()
    ).run()

  _reset: () =>
    @categoriseView.unsubscribeAll()
    @workingArea(null)
    @navigator.clear()

  _switchToBoard: (id) =>
    @navigator.idSelected(id)
    board = new nicetohave.Board(id, @privilege, @outstanding)
    @workingArea(new nicetohave.WorkingArea(board, @privilege, @outstanding))
    @categoriseView.subscribeTo(@workingArea().categorisations)
    @workingArea().load()

window.nicetohave.AppViewModel = AppViewModel