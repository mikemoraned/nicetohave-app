(function($, d3, global) {
    function D3CategoriseView(top, left, width, height) {
        this.maxRadius = 7;

        this.valueScale = d3.scale.linear()
            .domain([0, 3])
            .range([0, width])
            .clamp(true);

        this.riskScale = d3.scale.linear()
            .domain([0, 4])
            .range([0, height])
            .clamp(true);

        this.values = ['N','S','C'];
        this.risks = ['L','M','H','U'];

        this.brush = d3.svg.brush()
            .x(this.valueScale)
            .y(this.riskScale)
            .on("brushstart", this.brushstart(this))
            .on("brush", this.brush(this))
            .on("brushend", this.brushend(this));

        this.selecting = false;

        this.moveTo(top, left, width, height);
    }

    D3CategoriseView.prototype.moveTo = function(top, left, width, height) {
        this.svg = d3.select("body")
            .append("svg")
            .style("position", "absolute")
            .style("top", top + "px")
            .style("left", left + "px")
            .attr("width", width)
            .attr("height", height);

        this.svg.append("g")
            .attr("class", "brush")
            .call(this.brush);

        this.top = top;
        this.left = left;
        this.width = width;
        this.height = height;
    }

    D3CategoriseView.prototype.clampX = function(x) {
        return Math.max(this.maxRadius, Math.min(x, this.width - this.maxRadius))
    }

    D3CategoriseView.prototype.clampY = function(y) {
        return Math.max(this.maxRadius, Math.min(y, this.height - this.maxRadius))
    }

    D3CategoriseView.prototype.brushstart = function(self) {
        return function() {
            console.log("Brush Start");
            self.selecting = true;
            d3.select("body").classed("selecting", self.selecting);
        }
    }

    D3CategoriseView.prototype.brush = function(self) {
        return function() {
            console.log("Brush");
            var e = d3.event.target.extent();
            self.svg.selectAll("circle.card").classed("selected", function(c) {
                var value = self.valueScale.invert(c.x);
                var risk = self.riskScale.invert(c.y);
                var inSelection = e[0][0] <= value && value <= e[1][0]
                    && e[0][1] <= risk && risk <= e[1][1];
                c.selected(inSelection);
                return inSelection;
            });
        }
    }

    D3CategoriseView.prototype.brushend = function(self) {
        return function() {
            self.selecting = !d3.event.target.empty();
            console.log("Brush End, Selecting: " + self.selecting);
            d3.select("body").classed("selecting", self.selecting);
        }
    }

    D3CategoriseView.prototype.update = function(cards) {
        var self = this;

        var existingCards = this.svg.selectAll("circle.card")
            .data(cards, function(d) { return d.id(); });

        function updateCardClasses(d) {
            d3.select(this).classed("selected", d.selected());
            d3.select(this).classed("highlighted", d.highlighted());
        }

        var drag = d3.behavior.drag()
            .origin(Object)
            .on("drag", dragmove);

        function dragmove(d) {
            d3.select(this)
                .attr("cx", d.x = self.clampX(d3.event.x) )
                .attr("cy", d.y = self.clampY(d3.event.y) );
        }

        existingCards.each(updateCardClasses);

        var newCards = existingCards.enter();

        newCards
            .append("circle")
            .attr("class", "card")
            .attr("r", self.maxRadius)
            .attr("cx", function(d) { return d.x = self.clampX(self.valueScale(Math.random() * 3)); })
            .attr("cy", function(d) { return d.y = self.clampY(self.riskScale(3 + Math.random())); })
            .call(drag)
            .on("mouseover", function(c) {
                c.highlighted(true);
                d3.select(this).classed("highlighted", true);
            })
            .on("mouseout", function(c) {
                c.highlighted(false);
                d3.select(this).classed("highlighted", false);
            })
            .append("title")
            .text(function(c) { return c.name(); });

        existingCards.exit().remove();
    }

    global.D3CategoriseView = D3CategoriseView;
})(jQuery, d3, window);