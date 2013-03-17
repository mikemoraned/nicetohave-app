// Generated by CoffeeScript 1.6.1
(function() {
  var DummyCard, _ref,
    _this = this;

  if ((_ref = window.nicetohave) == null) {
    window.nicetohave = {};
  }

  DummyCard = (function() {

    function DummyCard(id) {
      var _this = this;
      this.addComment = function(comment) {
        return DummyCard.prototype.addComment.apply(_this, arguments);
      };
      this.name = ko.observable("A Dummy Card");
      this.comments = ko.observableArray();
      this.id = ko.observable(id);
    }

    DummyCard.prototype.addComment = function(comment) {
      return this.comments.unshift(comment);
    };

    return DummyCard;

  })();

  window.nicetohave.DummyCard = DummyCard;

}).call(this);
