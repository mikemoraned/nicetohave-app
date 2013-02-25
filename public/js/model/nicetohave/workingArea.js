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

      this.discardEdits = __bind(this.discardEdits, this);

      this.load = __bind(this.load, this);

      this.board = ko.observable(new nicetohave.Board("50f5c98fe0314ccd5500a51b", this.privilege));
      this.cards = ko.computed(function() {
        var cards, list, _i, _len, _ref1;
        cards = [];
        _ref1 = _this.board().lists();
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          list = _ref1[_i];
          cards = cards.concat(list.cards());
        }
        return cards;
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
      return this.board().load();
    };

    WorkingArea.prototype.discardEdits = function() {
      return this.haveEdits().forEach(function(h) {
        return h.discardEdits();
      });
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
