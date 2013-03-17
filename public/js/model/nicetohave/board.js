// Generated by CoffeeScript 1.6.1
(function() {
  var Board, _ref,
    _this = this;

  if ((_ref = window.nicetohave) == null) {
    window.nicetohave = {};
  }

  Board = (function() {

    function Board(id, privilege) {
      var _this = this;
      this._getList = function(id) {
        return Board.prototype._getList.apply(_this, arguments);
      };
      this._loadAllLists = function() {
        return Board.prototype._loadAllLists.apply(_this, arguments);
      };
      this._parseLists = function(data) {
        return Board.prototype._parseLists.apply(_this, arguments);
      };
      this._parseFields = function(data) {
        return Board.prototype._parseFields.apply(_this, arguments);
      };
      this.load = function() {
        return Board.prototype.load.apply(_this, arguments);
      };
      if (!/[a-z0-9]{24}/.test(id)) {
        throw {
          message: "Not a valid board id: '" + id + "'"
        };
      }
      this.id = ko.observable(id);
      this.privilege = privilege;
      this.loadStatus = ko.observable("created");
      this._existingLists = {};
      this.name = ko.observable("");
      this.lists = ko.observableArray();
    }

    Board.prototype.load = function() {
      var onFailure,
        _this = this;
      this.loadStatus("in-progress");
      onFailure = function() {
        return _this.loadStatus("load-failed");
      };
      return this.privilege.using(nicetohave.PrivilegeLevel.READ_ONLY, function(trello) {
        return trello.boards.get(_this.id(), {}, function(data) {
          _this._parseFields(data);
          return trello.boards.get(_this.id() + "/lists", {}, function(data) {
            _this._parseLists(data);
            _this._loadAllLists();
            return _this.loadStatus("load-success");
          }, onFailure);
        }, onFailure);
      });
    };

    Board.prototype._parseFields = function(data) {
      return this.name(data.name);
    };

    Board.prototype._parseLists = function(data) {
      var c;
      return this.lists((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          c = data[_i];
          _results.push(this._getList(c.id));
        }
        return _results;
      }).call(this));
    };

    Board.prototype._loadAllLists = function() {
      var list, _i, _len, _ref1, _results;
      _ref1 = this.lists();
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        list = _ref1[_i];
        _results.push(list.load());
      }
      return _results;
    };

    Board.prototype._getList = function(id) {
      if (this._existingLists[id] == null) {
        this._existingLists[id] = new nicetohave.List(id, this.privilege);
      }
      return this._existingLists[id];
    };

    return Board;

  })();

  window.nicetohave.Board = Board;

}).call(this);
