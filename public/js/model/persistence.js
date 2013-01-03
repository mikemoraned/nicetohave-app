(function(ko, Trello, global) {
    function Persistence() {
        // Data
        var self = this;
        self.pendingMovesToTop = ko.observableArray([]);
        self.errors = ko.observableArray([]);
        self.saving = ko.observable(false);

        self.saveState = ko.computed(function() {
            if (self.saving()) {
                return "saving";
            }
            else if (self.pendingMovesToTop().length == 0) {
                return "saved";
            }
            else {
                return "pending";
            }
        });

        self.canSaveAll = ko.computed(function() {
            return self.saveState() === 'pending';
        });

        // Events
        self.movedToTop = function(listId, cards) {
            cards.slice(0).reverse().forEach(function(card){
                self.pendingMovesToTop.push({
                    listId: listId,
                    cardId: card.id()
                });
            });
        }

        // Operations
        self.saveAll = function() {
            function moveNextToTop() {
                var next = self.pendingMovesToTop().shift();
                if (next) {
                    self.saving(true);
                    console.log("Moving to top:");
                    console.dir(next);
                    Trello.put(
                        "cards/" + next.cardId + "/pos",
                        { value: "top" },
                        function() {
                            console.log("Moved to top");
                            moveNextToTop();
                        },
                        failure
                    );
                }
                else {
                    self.saving(false);
                }
            }

            function failure(error) {
                console.log("Error");
                console.dir(error);
                self.errors.push(error);
                self.saving(false);
            }

            moveNextToTop();
        };
    }

    global.Persistence = Persistence;
})(ko, Trello, window);