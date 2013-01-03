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