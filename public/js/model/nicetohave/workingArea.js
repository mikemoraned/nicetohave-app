// Generated by CoffeeScript 1.4.0
(function() {
  var WorkingArea, _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  if ((_ref = window.nicetohave) == null) {
    window.nicetohave = {};
  }

  WorkingArea = (function() {

    function WorkingArea(privilege) {
      var _this = this;
      this.privilege = privilege;
      this.saveEdits = __bind(this.saveEdits, this);

      this.load = __bind(this.load, this);

      this.board = ko.observable(new nicetohave.Board("50f5c98fe0314ccd5500a51b", this.privilege));
      this.list = ko.observable(new nicetohave.List("50f5c98fe0314ccd5500a51d", this.privilege));
      this.cards = ko.computed(function() {
        return _this.list().cards();
      });
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
      this.haveEdits = ko.computed(function() {
        return _this.categorisations().filter(function(c) {
          return c.hasEdits();
        });
      });
      this.hasEdits = ko.computed(function() {
        return _this.haveEdits().length > 0;
      });
    }

    WorkingArea.prototype.load = function() {
      this.board().load();
      return this.list().load();
    };

    WorkingArea.prototype.saveEdits = function() {
      return this.haveEdits().forEach(function(h) {
        return h.saveEdits();
      });
    };

    return WorkingArea;

  })();

  window.nicetohave.WorkingArea = WorkingArea;

}).call(this);