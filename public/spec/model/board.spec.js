// Generated by CoffeeScript 1.6.1
(function() {

  describe('Board', function() {
    var outstanding,
      _this = this;
    outstanding = null;
    beforeEach(function() {
      return outstanding = new nicetohave.Outstanding();
    });
    describe('initial state', function() {
      it('cannot be created without an id', function() {
        return expect(function() {
          return new nicetohave.Board();
        }).toThrow({
          message: "Not a valid board id: 'undefined'"
        });
      });
      it('must only accept a long id of the right format (lower-case alphanumeric)', function() {
        expect(function() {
          return new nicetohave.Board("  csdc  scd");
        }).toThrow({
          message: "Not a valid board id: '  csdc  scd'"
        });
        return expect(function() {
          return new nicetohave.Board("4EEa503d91e31d174600008f");
        }).toThrow({
          message: "Not a valid board id: '4EEa503d91e31d174600008f'"
        });
      });
      it('must not accept an id of the wrong length', function() {
        return expect(function() {
          return new nicetohave.Board("4eea503d91e31d174600");
        }).toThrow({
          message: "Not a valid board id: '4eea503d91e31d174600'"
        });
      });
      it('must accept a long id of the right length (24)', function() {
        return expect(new nicetohave.Board("4eea503d91e31d174600008f").id()).toBe("4eea503d91e31d174600008f");
      });
      it('must accept a short id of the right length (8)', function() {
        return expect(new nicetohave.Board("gCrN8kMP").id()).toBe("gCrN8kMP");
      });
      it('has an empty name', function() {
        var board;
        board = new nicetohave.Board("4eea503d91e31d174600008f");
        return expect(board.name()).toBe("");
      });
      it('has an id', function() {
        var board;
        board = new nicetohave.Board("4eea503d91e31d174600008f");
        return expect(board.id()).toBe("4eea503d91e31d174600008f");
      });
      return it('has a created load status', function() {
        var board;
        board = new nicetohave.Board("4eea503d91e31d174600008f");
        return expect(board.loadStatus()).toBe("created");
      });
    });
    return describe('loading', function() {
      var boardResponse, boardsResponse, trello;
      trello = null;
      beforeEach(function() {
        trello = {
          boards: {
            get: function(path, params, successFn, errorFn) {}
          }
        };
        spyOn(trello.boards, 'get').andCallFake(function(path, params, successFn, errorFn) {
          if (path === '50f5c98fe0314ccd5500a51b') {
            return successFn(boardResponse);
          } else {
            if (path === '50f5c98fe0314ccd5500a51b/lists') {
              return successFn(boardsResponse);
            }
          }
        });
        return spyOn(nicetohave.List.prototype, "load");
      });
      it('when asked to load, loads name', function() {
        var board, privilige;
        privilige = new nicetohave.Privilege(trello);
        privilige.level(nicetohave.PrivilegeLevel.READ_ONLY);
        board = new nicetohave.Board("50f5c98fe0314ccd5500a51b", privilige, outstanding);
        board.load();
        expect(trello.boards.get).toHaveBeenCalled();
        return expect(board.name()).toEqual("NiceToHaveTestBoard");
      });
      it('when asked to load, and callback provided, calls on success', function() {
        var board, obj, privilige;
        privilige = new nicetohave.Privilege(trello);
        privilige.level(nicetohave.PrivilegeLevel.READ_ONLY);
        board = new nicetohave.Board("50f5c98fe0314ccd5500a51b", privilige, outstanding);
        obj = {
          callback: function() {}
        };
        spyOn(obj, 'callback');
        board.load(obj.callback);
        return expect(obj.callback).toHaveBeenCalled();
      });
      it('when asked to load, loads lists with ids', function() {
        var board, privilige;
        privilige = new nicetohave.Privilege(trello);
        privilige.level(nicetohave.PrivilegeLevel.READ_ONLY);
        board = new nicetohave.Board("50f5c98fe0314ccd5500a51b", privilige, outstanding);
        expect(board.loadStatus()).toEqual("created");
        board.load();
        expect(board.loadStatus()).toEqual("load-success");
        expect(trello.boards.get).toHaveBeenCalled();
        expect(board.lists().length).toEqual(3);
        expect(board.lists()[0].id()).toEqual("50f5c98fe0314ccd5500a51c");
        expect(board.lists()[1].id()).toEqual("50f5c98fe0314ccd5500a51d");
        return expect(board.lists()[2].id()).toEqual("50f5c98fe0314ccd5500a51e");
      });
      it('when asked to load twice, re-use existing list objects for same id', function() {
        var board, list1, list2, list3, privilige, _ref;
        privilige = new nicetohave.Privilege(trello);
        privilige.level(nicetohave.PrivilegeLevel.READ_ONLY);
        board = new nicetohave.Board("50f5c98fe0314ccd5500a51b", privilige, outstanding);
        expect(board.loadStatus()).toEqual("created");
        board.load();
        expect(board.loadStatus()).toEqual("load-success");
        expect(trello.boards.get).toHaveBeenCalled();
        expect(board.lists().length).toEqual(3);
        expect(board.lists()[0].id()).toEqual("50f5c98fe0314ccd5500a51c");
        expect(board.lists()[1].id()).toEqual("50f5c98fe0314ccd5500a51d");
        expect(board.lists()[2].id()).toEqual("50f5c98fe0314ccd5500a51e");
        _ref = board.lists(), list1 = _ref[0], list2 = _ref[1], list3 = _ref[2];
        board.load();
        expect(board.lists().length).toEqual(3);
        expect(board.lists()[0]).toBe(list1);
        expect(board.lists()[1]).toBe(list2);
        return expect(board.lists()[2]).toBe(list3);
      });
      it('when asked to load, call load on List', function() {
        var board, privilige;
        privilige = new nicetohave.Privilege(trello);
        privilige.level(nicetohave.PrivilegeLevel.READ_ONLY);
        board = new nicetohave.Board("50f5c98fe0314ccd5500a51b", privilige, outstanding);
        expect(board.loadStatus()).toEqual("created");
        board.load();
        expect(board.loadStatus()).toEqual("load-success");
        return expect(nicetohave.List.prototype.load).toHaveBeenCalled();
      });
      boardResponse = JSON.parse("{\"id\":\"50f5c98fe0314ccd5500a51b\",\"name\":\"NiceToHaveTestBoard\",\"desc\":\"\",\"closed\":false,\"idOrganization\":null,\"pinned\":true,\"url\":\"https://trello.com/board/nicetohavetestboard/50f5c98fe0314ccd5500a51b\",\"prefs\":{\"permissionLevel\":\"private\",\"voting\":\"members\",\"comments\":\"members\",\"invitations\":\"members\",\"selfJoin\":false,\"listCovers\":true},\"labelNames\":{\"red\":\"\",\"orange\":\"\",\"yellow\":\"\",\"green\":\"\",\"blue\":\"\",\"purple\":\"\"}}");
      return boardsResponse = JSON.parse("[{\"id\":\"50f5c98fe0314ccd5500a51c\",\"name\":\"To Do\",\"closed\":false,\"idBoard\":\"50f5c98fe0314ccd5500a51b\",\"pos\":16384,\"subscribed\":false},{\"id\":\"50f5c98fe0314ccd5500a51d\",\"name\":\"Doing\",\"closed\":false,\"idBoard\":\"50f5c98fe0314ccd5500a51b\",\"pos\":32768,\"subscribed\":false},{\"id\":\"50f5c98fe0314ccd5500a51e\",\"name\":\"Done\",\"closed\":false,\"idBoard\":\"50f5c98fe0314ccd5500a51b\",\"pos\":49152,\"subscribed\":false}]");
    });
  });

}).call(this);
