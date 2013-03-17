// Generated by CoffeeScript 1.6.1
(function() {
  var Categorisation, CommentPosition, EditablePosition, Position, _ref,
    _this = this,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  if ((_ref = window.nicetohave) == null) {
    window.nicetohave = {};
  }

  Position = (function() {

    function Position(v) {
      var _this = this;
      this.hasValue = function() {
        return Position.prototype.hasValue.apply(_this, arguments);
      };
      this._v = ko.observable(v != null ? this.normalize(v) : null);
    }

    Position.prototype.hasValue = function() {
      return this.value() != null;
    };

    Position.prototype.clamp = function(v) {
      return Math.min(1.0, Math.max(0.0, v));
    };

    Position.prototype.normalize = function(v) {
      return parseFloat(this.clamp(v).toFixed(3));
    };

    return Position;

  })();

  CommentPosition = (function(_super) {

    __extends(CommentPosition, _super);

    function CommentPosition(v) {
      var _this = this;
      CommentPosition.__super__.constructor.call(this, v);
      this.value = ko.computed({
        read: this._v,
        write: function(v) {
          if (v != null) {
            return _this._v(_this.normalize(v));
          } else {
            return _this._v(null);
          }
        }
      });
    }

    return CommentPosition;

  })(Position);

  EditablePosition = (function(_super) {

    __extends(EditablePosition, _super);

    function EditablePosition(commentPos) {
      var _this = this;
      this.discardEdits = function() {
        return EditablePosition.prototype.discardEdits.apply(_this, arguments);
      };
      EditablePosition.__super__.constructor.call(this, null);
      this.value = ko.computed({
        read: function() {
          if (_this._v() != null) {
            return _this._v();
          } else {
            return commentPos.value();
          }
        },
        write: function(v) {
          if (v != null) {
            return _this._v(_this.normalize(v));
          } else {
            return _this._v(null);
          }
        }
      });
      this.hasEdits = ko.computed(function() {
        console.log("my: " + (_this.value()) + ", comment: " + (commentPos.value()));
        return _this.value() !== commentPos.value();
      });
    }

    EditablePosition.prototype.discardEdits = function() {
      return this._v(null);
    };

    return EditablePosition;

  })(Position);

  Categorisation = (function() {

    function Categorisation(card) {
      var _this = this;
      this._updateCommentValues = function(comments) {
        return Categorisation.prototype._updateCommentValues.apply(_this, arguments);
      };
      this.saveEdits = function() {
        return Categorisation.prototype.saveEdits.apply(_this, arguments);
      };
      this.discardEdits = function() {
        return Categorisation.prototype.discardEdits.apply(_this, arguments);
      };
      this.axis = function(name) {
        return Categorisation.prototype.axis.apply(_this, arguments);
      };
      this.fullyDefined = function() {
        return Categorisation.prototype.fullyDefined.apply(_this, arguments);
      };
      this.card = card;
      this.commentRisk = new CommentPosition();
      this.commentValue = new CommentPosition();
      this.editableRisk = new EditablePosition(this.commentRisk);
      this.editableValue = new EditablePosition(this.commentValue);
      this._updateCommentValues(this.card.comments());
      this.card.comments.subscribe(this._updateCommentValues);
      this.axes = ko.computed(function() {
        return [
          {
            name: "risk",
            position: _this.editableRisk
          }, {
            name: "value",
            position: _this.editableValue
          }
        ];
      });
      this.hasEdits = ko.computed(function() {
        return _this.editableRisk.hasEdits() || _this.editableValue.hasEdits();
      });
    }

    Categorisation.prototype.fullyDefined = function() {
      return this.editableRisk.hasValue() && this.editableRisk.hasValue();
    };

    Categorisation.prototype.axis = function(name) {
      if (name === "risk") {
        return this.editableRisk;
      } else if (name === "value") {
        return this.editableValue;
      } else {
        return null;
      }
    };

    Categorisation.prototype.discardEdits = function() {
      if (this.hasEdits()) {
        this.editableRisk.discardEdits();
        return this.editableValue.discardEdits();
      }
    };

    Categorisation.prototype.saveEdits = function() {
      var formatted;
      if (this.hasEdits()) {
        formatted = [];
        if (this.editableRisk.hasEdits()) {
          formatted.push("risk:" + (this.editableRisk.value()));
        }
        if (this.editableValue.hasEdits()) {
          formatted.push("value:" + (this.editableValue.value()));
        }
        this.card.addComment(new nicetohave.Comment(formatted.join(" ")));
        this.editableRisk.discardEdits();
        return this.editableValue.discardEdits();
      }
    };

    Categorisation.prototype._updateCommentValues = function(comments) {
      var axes, comment, foundValue, name, _i, _j, _len, _len1, _ref1, _results;
      console.log("Updating based on comments for " + (this.card.name()));
      console.dir(comments);
      foundValue = {
        "risk": false,
        "value": false
      };
      axes = {
        "risk": this.commentRisk,
        "value": this.commentValue
      };
      for (_i = 0, _len = comments.length; _i < _len; _i++) {
        comment = comments[_i];
        this._parseComment(comment.text(), axes, foundValue);
      }
      _ref1 = ["risk", "value"];
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        name = _ref1[_j];
        if (!foundValue[name]) {
          _results.push(axes[name].value(null));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Categorisation.prototype._parseComment = function(text, axes, foundValue) {
      var axis, match, re, _results;
      re = /(risk|value):([\d.]+)/g;
      _results = [];
      while ((match = re.exec(text))) {
        axis = match[1];
        if (!foundValue[axis]) {
          axes[axis].value(parseFloat(match[2]));
          _results.push(foundValue[axis] = true);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    return Categorisation;

  })();

  window.nicetohave.Categorisation = Categorisation;

}).call(this);
