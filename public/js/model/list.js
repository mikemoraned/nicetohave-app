(function(ko, Trello, global) {
    function List(data, persistence) {
        var self = this;
        self.id = ko.observable(data.id);
        self.name = ko.observable(data.name);
        self.cards = ko.observableArray([]);
        self.persistence = persistence;

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

                self.persistence.movedToTop(self.id(), selected);

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

        self.refresh = function() {
            Trello.lists.get(self.id() + "/cards", function(trelloCards) {
                console.log("Fetched cards");
                console.dir(trelloCards);

                var newOrUpdatedCards = [];

                var position = 0;
                var totalCards = trelloCards.length;
                trelloCards.forEach(function(trelloCard) {
                    var existing = self.cards().filter(function(c){ return c.id() === trelloCard.id; });
                    if (existing.length > 0) {
                        console.log("Re-using existing card");
                        newOrUpdatedCards.push(existing[0].update(trelloCard, position, totalCards));
                    }
                    else {
                        console.log("Creating new card");
                        newOrUpdatedCards.push(new Card(trelloCard, position, totalCards));
                    }
                    position += 1;
                });

                self.cards(newOrUpdatedCards);
            });
        }
    }

    global.List = List;
})(ko, Trello, window);