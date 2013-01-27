// Generated by CoffeeScript 1.4.0
(function() {

  describe('Privilege', function() {
    describe('initial state', function() {
      return it('starts off with no priviliges', function() {
        return expect(new nicetohave.Privilege().level()).toEqual(nicetohave.PrivilegeLevel.NONE);
      });
    });
    return describe('authorization', function() {
      var trello;
      trello = null;
      beforeEach(function() {
        return trello = {
          authorize: function(opts) {}
        };
      });
      it('when needs to go from none to read-only, asks for authorization', function() {
        var privilige;
        privilige = new nicetohave.Privilege(trello);
        spyOn(trello, 'authorize').andCallFake(function(opts) {
          return opts.success();
        });
        privilige.using(nicetohave.PrivilegeLevel.READ_ONLY, function(trello) {});
        expect(trello.authorize).toHaveBeenCalled();
        return expect(privilige.level()).toEqual(nicetohave.PrivilegeLevel.READ_ONLY);
      });
      return it('when already at required privilige level, then does not ask for authorization', function() {
        var privilige;
        privilige = new nicetohave.Privilege(trello);
        privilige.level(nicetohave.PrivilegeLevel.READ_ONLY);
        spyOn(trello, 'authorize');
        privilige.using(nicetohave.PrivilegeLevel.READ_ONLY, function(trello) {});
        expect(trello.authorize).not.toHaveBeenCalled();
        return expect(privilige.level()).toEqual(nicetohave.PrivilegeLevel.READ_ONLY);
      });
    });
  });

}).call(this);
