// Generated by CoffeeScript 1.4.0
(function() {
  var AppViewModel, _ref;

  if ((_ref = window.nicetohave) == null) {
    window.nicetohave = {};
  }

  AppViewModel = (function() {

    function AppViewModel() {
      var _this = this;
      this.privilege = new nicetohave.Privilege(Trello);
      this.cards = ko.observableArray([new nicetohave.Card("510557f3e002eb8d56002e04", this.privilege), new nicetohave.Card("5105af6108fa2a6e21000dc5", this.privilege)]);
      this._cachedCategorisations = {};
      this.categorisations = ko.computed(function() {
        return _this.cards().map(function(card) {
          if (_this._cachedCategorisations[card.id()]) {
            return _this._cachedCategorisations[card.id()];
          } else {
            _this._cachedCategorisations[card.id()] = new nicetohave.Categorisation(card);
            return _this._cachedCategorisations[card.id()];
          }
        });
      });
    }

    return AppViewModel;

  })();

  window.nicetohave.AppViewModel = AppViewModel;

}).call(this);
