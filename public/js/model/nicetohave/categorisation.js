// Generated by CoffeeScript 1.4.0
(function() {
  var Categorisation, Position, _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  if ((_ref = window.nicetohave) == null) {
    window.nicetohave = {};
  }

  Position = (function() {

    function Position(v) {
      this.v = v;
      this.value = __bind(this.value, this);

      this.hasValue = __bind(this.hasValue, this);

      if (this.v > 1.0) {
        this.v = 1.0;
      }
      if (this.v < 0.0) {
        this.v = 0.0;
      }
    }

    Position.prototype.hasValue = function() {
      return this.v != null;
    };

    Position.prototype.value = function() {
      return this.v;
    };

    return Position;

  })();

  Categorisation = (function() {

    function Categorisation(card) {
      this.axis = __bind(this.axis, this);

      var _this = this;
      this.card = card;
      this.axes = ko.computed(function() {
        var axes, comment, _i, _len, _ref1;
        axes = {
          "risk": new Position(),
          "value": new Position()
        };
        if (_this.card.hasComments()) {
          _ref1 = _this.card.comments();
          for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
            comment = _ref1[_i];
            if (_this._parseComment(comment.text(), axes)) {
              break;
            }
          }
        }
        return axes;
      });
    }

    Categorisation.prototype.axis = function(name) {
      var position;
      position = this.axes()[name];
      return position;
    };

    Categorisation.prototype._parseComment = function(text, axes) {
      var axis, match, matched, re, value;
      re = /(risk|value):([\d.]+)/g;
      matched = false;
      while ((match = re.exec(text))) {
        matched = true;
        axis = match[1];
        value = parseFloat(match[2]);
        axes[axis] = new Position(value);
      }
      return matched;
    };

    return Categorisation;

  })();

  window.nicetohave.Categorisation = Categorisation;

}).call(this);