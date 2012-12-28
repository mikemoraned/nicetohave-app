(function(ko, Trello, global) {
    function Board(defaultBoardId) {
        // Data
        var self = this;
        self.id = ko.observable(defaultBoardId);
        self.lists = ko.observableArray([]);
        self.name = ko.observable("");

        function handleResults(results) {
            console.log("Fetched board info");
            console.dir(results);
            self.name(results.name);
            Trello.boards.get(self.id() + "/lists", function(results) {
                console.log("Fetched board lists");
                self.lists([]);
                console.dir(results);
                results.forEach(function(d) {
                    self.lists.push(new List(d));
                })
            });
        };

        function onError(error) {
            console.dir(error);
            if (error.status === 401) {
                Trello.authorize({
                    type: "popup",
                    name: "Nice to have",
                    success: function(foop){
                        console.log("Authorize succeeded");
                        console.dir(foop);
                    },
                    error: function(error) {
                        console.log("Authorize failed");
                        console.dir(error);
                    }
                });
            }
        }

        // Operations
        self.refresh = function() {
            console.log("Asked to refresh");
            Trello.boards.get(self.id(), handleResults, onError);
        }
    }

    global.Board = Board;
})(ko, Trello, window);