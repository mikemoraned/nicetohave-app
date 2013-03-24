// Generated by CoffeeScript 1.6.1
(function() {
  var Card, _ref,
    _this = this;

  if ((_ref = window.nicetohave) == null) {
    window.nicetohave = {};
  }

  Card = (function() {

    function Card(id, privilege, outstanding) {
      var _this = this;
      this.outstanding = outstanding;
      this._parseComments = function(data) {
        return Card.prototype._parseComments.apply(_this, arguments);
      };
      this._parseFields = function(data) {
        return Card.prototype._parseFields.apply(_this, arguments);
      };
      this._loadComments = function() {
        return Card.prototype._loadComments.apply(_this, arguments);
      };
      this.addComment = function(comment) {
        return Card.prototype.addComment.apply(_this, arguments);
      };
      this.load = function() {
        return Card.prototype.load.apply(_this, arguments);
      };
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
      this.outstanding.started();
      onSuccess = function(data) {
        _this._parseFields(data);
        _this._loadComments();
        return _this.outstanding.completed();
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
      this.outstanding.started();
      onSuccess = function() {
        _this.loadStatus("saved");
        _this.load();
        return _this.outstanding.completed();
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
      this.outstanding.started();
      onSuccess = function(data) {
        _this._parseComments(data);
        _this.loadStatus("loaded");
        return _this.outstanding.completed();
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
      if (data === null || typeof data === "undefined") {
        return console.log("Something wierd happening, ignoring for now");
      } else {
        return this.name(data.name);
      }
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
