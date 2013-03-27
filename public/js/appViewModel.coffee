window.nicetohave ?= {}

class AppViewModel

  constructor: ->
    @trello = new nicetohave.trello.TrelloQueue(Trello)
    @privilege = new nicetohave.Privilege(@trello)
    @notifications = new nicetohave.Notifications(@privilege)
    @outstanding = new nicetohave.Outstanding()
    @workingArea = ko.observable()
    @categoriseView = new nicetohave.D3CategorisationView("svg", 1200, 600)

  run: =>
    Sammy((sammy) =>
      sammy.get('#:boardId', (context) =>
        @_switchToBoard(context.params.boardId)
      )
    ).run()

  _switchToBoard: (id) =>
    board = new nicetohave.Board(id, @privilege, @outstanding)
    @workingArea(new nicetohave.WorkingArea(board, @privilege, @outstanding))
    @categoriseView.subscribeTo(@workingArea().categorisations)
    @workingArea().load()

window.nicetohave.AppViewModel = AppViewModel