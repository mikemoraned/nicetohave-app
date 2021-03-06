// Generated by CoffeeScript 1.4.0
(function() {

  describe('Card integ tests', function() {
    return describe('loading from test board', function() {
      beforeEach(function() {
        return Trello.deauthorize();
      });
      it('when asked to load existing card, loads name', function() {
        var card, privilege;
        privilege = new nicetohave.Privilege(Trello);
        card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege);
        expect(card.name()).toBe("");
        runs(function() {
          return card.load();
        });
        waitsFor(function() {
          return card.loadStatus() === "loaded";
        });
        return runs(function() {
          return expect(card.name()).toBe("Test card");
        });
      });
      return it('when asked to load existing card with comments, loads them all', function() {
        var card, privilege;
        privilege = new nicetohave.Privilege(Trello);
        card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege);
        runs(function() {
          return card.load();
        });
        waitsFor(function() {
          return card.loadStatus() === "loaded";
        });
        return runs(function() {
          expect(card.comments().length).toEqual(1);
          return expect(card.comments()[0].text()).toEqual("This is a comment");
        });
      });
    });
  });

}).call(this);
