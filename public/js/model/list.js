(function(ko, Trello, global) {
    function List(data) {
        var self = this;
        self.id = ko.observable(data.id);
        self.name = ko.observable(data.name);
        self.cards = ko.observableArray([]);
        self.cardsInArea = ko.computed(function() {
            return self.cards().filter(function(c) {
                return c.inArea();
            });
        });

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

                self.cards(selected.concat(remaining));
            }
        }

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