// Generated by CoffeeScript 1.6.1
(function() {
  var AppViewModel, _ref,
    _this = this;

  if ((_ref = window.nicetohave) == null) {
    window.nicetohave = {};
  }

  AppViewModel = (function() {

    function AppViewModel() {
      var _this = this;
      this._switchToBoard = function(id) {
        return AppViewModel.prototype._switchToBoard.apply(_this, arguments);
      };
      this.run = function() {
        return AppViewModel.prototype.run.apply(_this, arguments);
      };
      this.trello = new nicetohave.trello.TrelloQueue(Trello);
      this.privilege = new nicetohave.Privilege(this.trello);
      this.notifications = new nicetohave.Notifications(this.privilege);
      this.outstanding = new nicetohave.Outstanding();
      this.workingArea = ko.observable();
      this.categoriseView = new nicetohave.D3CategorisationView("svg", 1200, 600);
      this.navigator = new nicetohave.Navigator();
      this.chooser = new nicetohave.Chooser(this.navigator);
    }

    AppViewModel.prototype.run = function() {
      var _this = this;
      return Sammy(function(sammy) {
        return sammy.get('#:boardId', function(context) {
          return _this._switchToBoard(context.params.boardId);
        });
      }).run();
    };

    AppViewModel.prototype._switchToBoard = function(id) {
      var board;
      this.navigator.idSelected(id);
      board = new nicetohave.Board(id, this.privilege, this.outstanding);
      this.workingArea(new nicetohave.WorkingArea(board, this.privilege, this.outstanding));
      this.categoriseView.subscribeTo(this.workingArea().categorisations);
      return this.workingArea().load();
    };

    return AppViewModel;

  })();

  window.nicetohave.AppViewModel = AppViewModel;

}).call(this);
