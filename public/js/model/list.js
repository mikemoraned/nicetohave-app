(function(ko, Trello, global) {
    function MoveToTop(listId, cardId) {
        this.listId = listId;
        this.cardId = cardId;
    }

    MoveToTop.prototype.do = function (success, failure) {
        console.log("Moving " + this.cardId + " to top of " + this.listId);
        Trello.put("cards/" + this.cardId + "/pos", { value: "top" }, success, failure);
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

        self.hasSomeNotInArea = ko.computed(function() {
            return self.cards().filter(function(c) {
                return !c.inArea();
            }).length > 0;
        });

        self.addAllToArea = function() {
            self.cards().forEach(function(c){
                if (!c.inArea()) {
                    c.inArea(true);
                }
            })
        };

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
                var position = 0;
                results.forEach(function(d, i) {
                    self.cards.push(new Card(d, i, results.length));
                })
            });
        }
    }

    global.List = List;
})(ko, Trello, window);