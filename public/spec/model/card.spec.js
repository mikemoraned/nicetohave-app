// Generated by CoffeeScript 1.4.0
(function() {

  describe('Card', function() {
    describe('initial state', function() {
      it('cannot be created without an id', function() {
        return expect(function() {
          return new nicetohave.Card();
        }).toThrow({
          message: "Not a valid card id: 'undefined'"
        });
      });
      it('must only accept an id of the right format (alphanumeric)', function() {
        return expect(function() {
          return new nicetohave.Card("  csdc  scd");
        }).toThrow({
          message: "Not a valid card id: '  csdc  scd'"
        });
      });
      it('must only accept an id of the right length (24  )', function() {
        return expect(function() {
          return new nicetohave.Card("4eea503d91e31d174600");
        }).toThrow({
          message: "Not a valid card id: '4eea503d91e31d174600'"
        });
      });
      it('has an empty name', function() {
        var card;
        card = new nicetohave.Card("4eea503d91e31d174600008f");
        return expect(card.name()).toBe("");
      });
      it('has an id', function() {
        var card;
        card = new nicetohave.Card("4eea503d91e31d174600008f");
        return expect(card.id()).toBe("4eea503d91e31d174600008f");
      });
      return it('has a created load status', function() {
        var card;
        card = new nicetohave.Card("4eea503d91e31d174600008f");
        return expect(card.loadStatus()).toBe("created");
      });
    });
    return describe('loading', function() {
      var trello;
      trello = null;
      beforeEach(function() {
        return trello = {
          cards: {
            get: function(id, params, successFn, errorFn) {}
          }
        };
      });
      return it('when asked to load, loads name', function() {
        var card, privilige;
        privilige = new nicetohave.Privilege(trello);
        card = new nicetohave.Card("4eea503d91e31d174600008f", privilige);
        spyOn(trello.cards, 'get');
        card.load();
        return expect(trello.cards.get).toHaveBeenCalled();
      });
    });
  });

}).call(this);
