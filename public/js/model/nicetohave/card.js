// Generated by CoffeeScript 1.4.0
(function() {
  var Card, _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  if ((_ref = window.nicetohave) == null) {
    window.nicetohave = {};
  }

  Card = (function() {

    function Card(id, privilege) {
      this._parseComments = __bind(this._parseComments, this);

      this._parseFields = __bind(this._parseFields, this);

      this._loadComments = __bind(this._loadComments, this);

      this.addComment = __bind(this.addComment, this);

      this.load = __bind(this.load, this);

      var _this = this;
      if (!/[a-z0-9]{24}/.test(id)) {
        throw {
          message: "Not a valid card id: '" + id + "'"
        };
      }
      this.id = ko.observable(id);
      this.privilege = privilege;
      this.name = ko.observable("");
      this.comments = ko.observableArray();
      this.loadStatus = ko.observable("created");
      this.hasComments = ko.computed(function() {
        return _this.comments().length > 0;
      });
    }

    Card.prototype.load = function() {
      var onFailure, onSuccess,
        _this = this;
      this.loadStatus("in-progress");
      onSuccess = function(data) {
        _this._parseFields(data);
        return _this._loadComments();
      };
      onFailure = function() {
        return _this.loadStatus("load-failed");
      };
      return this.privilege.using(nicetohave.PrivilegeLevel.READ_ONLY, function(trello) {
        return trello.cards.get(_this.id(), {
          fields: "name"
        }, onSuccess, onFailure);
      });
    };

    Card.prototype.addComment = function(comment) {
      var onFailure, onSuccess,
        _this = this;
      onSuccess = function() {
        _this.loadStatus("saved");
        return _this.load();
      };
      onFailure = function() {
        return _this.loadStatus("save-failed");
      };
      return this.privilege.using(nicetohave.PrivilegeLevel.READ_WRITE, function(trello) {
        return trello.post("/cards/" + _this.id() + "/actions/comments", {
          text: comment.text()
        }, onSuccess, onFailure);
      });
    };

    Card.prototype._loadComments = function() {
      var onFailure, onSuccess,
        _this = this;
      onSuccess = function(data) {
        _this._parseComments(data);
        return _this.loadStatus("loaded");
      };
      onFailure = function() {
        return _this.loadStatus("load-failed");
      };
      return this.privilege.using(nicetohave.PrivilegeLevel.READ_ONLY, function(trello) {
        return trello.cards.get(_this.id() + "/actions", {
          entities: true,
          filter: "commentCard"
        }, onSuccess, onFailure);
      });
    };

    Card.prototype._parseFields = function(data) {
      return this.name(data.name);
    };

    Card.prototype._parseComments = function(data) {
      return this.comments(data.map(function(d) {
        var e, texts;
        texts = (function() {
          var _i, _len, _ref1, _results;
          _ref1 = d.entities;
          _results = [];
          for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
            e = _ref1[_i];
            if (e.type === 'comment') {
              _results.push(e.text);
            }
          }
          return _results;
        })();
        return new nicetohave.Comment(texts[0]);
      }));
    };

    return Card;

  })();

  window.nicetohave.Card = Card;

}).call(this);
