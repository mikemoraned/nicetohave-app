(function(ko, global){
    function Card(data, posInList, totalCards) {
        var self = this;
        self.id = ko.observable(data.id);
        self.name = ko.observable(data.name);
        self.selected = ko.observable(false);
        self.highlighted = ko.observable(false);
        self.inArea = ko.observable(false);

        self.fractionThroughList = posInList / totalCards;

        self.update = function(data, posInList, totalCards) {
            ko.observable(data.id);
            ko.observable(data.name);
            self.fractionThroughList = posInList / totalCards;
            return self;
        }

        self.highlight = function() {
            self.highlighted(true);
        }

        self.unHighlight = function() {
            self.highlighted(false);
        }

        self.addToArea = function() {
            self.inArea(true);
        };

        self.removeFromArea = function() {
            self.inArea(false);
        };
    }

    global.Card = Card;
})(ko, window);