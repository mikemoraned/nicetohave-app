// Generated by CoffeeScript 1.4.0
(function() {
  var List, _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  if ((_ref = window.nicetohave) == null) {
    window.nicetohave = {};
  }

  List = (function() {

    function List(id, privilege) {
      this._getCard = __bind(this._getCard, this);

      this._loadAllCards = __bind(this._loadAllCards, this);

      this._parseCards = __bind(this._parseCards, this);

      this._parseFields = __bind(this._parseFields, this);

      this.load = __bind(this.load, this);
      if (!/[a-z0-9]{24}/.test(id)) {
        throw {
          message: "Not a valid list id: '" + id + "'"
        };
      }
      this.id = ko.observable(id);
      this.privilege = privilege;
      this.loadStatus = ko.observable("created");
      this._existingCards = {};
      this.name = ko.observable("");
      this.cards = ko.observableArray();
    }

    List.prototype.load = function() {
      var onFailure,
        _this = this;
      this.loadStatus("in-progress");
      onFailure = function() {
        return _this.loadStatus("load-failed");
      };
      return this.privilege.using(nicetohave.PrivilegeLevel.READ_ONLY, function(trello) {
        return trello.lists.get(_this.id(), {}, function(data) {
          _this._parseFields(data);
          return trello.lists.get(_this.id() + "/cards", {}, function(data) {
            _this._parseCards(data);
            _this._loadAllCards();
            return _this.loadStatus("load-success");
          }, onFailure);
        }, onFailure);
      });
    };

    List.prototype._parseFields = function(data) {
      if (data != null) {
        return this.name(data.name);
      } else {
        return console.log("Workaround for list data being undefined and then later defined, https://trello.com/c/k2VKLuJg");
      }
    };

    List.prototype._parseCards = function(data) {
      var c;
      return this.cards((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          c = data[_i];
          _results.push(this._getCard(c.id));
        }
        return _results;
      }).call(this));
    };

    List.prototype._loadAllCards = function() {
      var card, _i, _len, _ref1, _results;
      _ref1 = this.cards();
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        card = _ref1[_i];
        _results.push(card.load());
      }
      return _results;
    };

    List.prototype._getCard = function(id) {
      if (!(this._existingCards[id] != null)) {
        this._existingCards[id] = new nicetohave.Card(id, this.privilege);
      }
      return this._existingCards[id];
    };

    return List;

  })();

  window.nicetohave.List = List;

}).call(this);
