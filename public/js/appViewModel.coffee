window.nicetohave ?= {}

class AppViewModel

  constructor: ->
    @privilege = new nicetohave.Privilege(Trello)
    @workingArea = ko.observable()
    @categoriseView = new nicetohave.D3CategorisationView("svg", 800, 600)

  run: =>
    Sammy((sammy) =>
      sammy.get('#:boardId', (context) =>
        @_switchToBoard(context.params.boardId)
      )
    ).run()

  _switchToBoard: (id) =>
    board = new nicetohave.Board(id, @privilege)
    @workingArea(new nicetohave.WorkingArea(board, @privilege))
    @categoriseView.subscribeTo(@workingArea().categorisations)
    @workingArea().load()

window.nicetohave.AppViewModel = AppViewModel