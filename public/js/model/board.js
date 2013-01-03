(function(ko, Trello, global) {
    function Board(persistence) {
        // Data
        var self = this;
        self.id = ko.observable();
        self.lists = ko.observableArray([]);
        self.name = ko.observable("");
        self.persistence = persistence;

        function handleResults(results) {
            console.log("Fetched board info");
            console.dir(results);
            self.name(results.name);
            Trello.boards.get(self.id() + "/lists", function(lists) {
                console.log("Fetched board lists");
                self.lists([]);
                lists.forEach(function(d) {
                    self.lists.push(new List(d, self.persistence));
                })
            });
        };

        function onError(error) {
            console.dir(error);
            if (error.status === 401) {
                Trello.authorize({
                    type: "popup",
                    name: "Nice to have",
                    success: function(){
                        console.log("Authorize succeeded");
                        self.refresh();
                    },
                    error: function(error) {
                        console.log("Authorize failed");
                        console.dir(error);
                    },
                    scope: {
                        read: true, write: true
                    }
                });
            }
        }

        self.goToBoardId = function(id) {
            self.id(id);
            self.refresh();
        };

        // Operations
        self.refresh = function() {
            console.log("Asked to refresh");
            Trello.boards.get(self.id(), handleResults, onError);
        }
    }

    global.Board = Board;
})(ko, Trello, window);