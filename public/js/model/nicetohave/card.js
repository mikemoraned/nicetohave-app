// Generated by CoffeeScript 1.4.0
(function() {
  var Card, _ref;

  if ((_ref = window.nicetohave) == null) {
    window.nicetohave = {};
  }

  Card = (function() {

    function Card(id) {
      if (!/[a-z0-9]{24}/.test(id)) {
        throw {
          message: "Not a valid card id: '" + id + "'"
        };
      }
    }

    Card.prototype.name = ko.observable("");

    return Card;

  })();

  window.nicetohave.Card = Card;

}).call(this);
