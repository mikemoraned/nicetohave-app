(function(ko, Trello, global) {
    function MoveToTop(listId, cardId) {
        this.listId = listId;
        this.cardId = cardId;
    }

    MoveToTop.prototype.do = function (success, failure) {
        console.log("Moving " + this.cardId + " to top of " + this.listId);
        success();
    }

    function List(data) {
        var self = this;
        self.id = ko.observable(data.id);
        self.name = ko.observable(data.name);
        self.cards = ko.observableArray([]);

        self.hasSelected = ko.computed(function() {
            return self.cards().filter(function(c) {
                return c.selected();
            }).length > 0;
        });

        self.moveSelectedToTop = function() {
            if (self.hasSelected()) {
                var selected = self.cards().filter(function(c) {
                    return c.selected();
                });
                var remaining = self.cards().filter(function(c) {
                    return !c.selected();
                });
                console.log("Selected:");
                console.dir(selected);
                console.log("Remaining:");
                console.dir(remaining);

                selected.forEach(function(c) {
                    self.pendingActions.push(new MoveToTop(self.id(), c.id()));
                });

                self.cards(selected.concat(remaining));
            }
        }

        self.pendingActions = ko.observableArray([]);

        self.hasPendingActions = ko.computed(function() {
            return self.pendingActions().length > 0;
        });

        self.doPendingActions = function() {
            console.log("Doing pending actions");
            self.pendingActions().forEach(function(action) {
                action.do(self.refresh, function(error) {
                    console.log("Error:");
                    console.dir(error);
                });
            });
            self.pendingActions([]);
        };

        self.refresh = function() {
            Trello.lists.get(self.id() + "/cards", function(results) {
                console.log("Fetched cards");
                console.dir(results);
                self.cards([]);
                results.forEach(function(d) {
                    self.cards.push(new Card(d));
                })
            });
        }
    }

    global.List = List;
})(ko, Trello, window);