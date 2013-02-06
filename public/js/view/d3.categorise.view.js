(function($, d3, global) {
    function D3CategoriseView(top, left, width, height) {
        this.maxRadius = 7;
        this.selecting = false;
        this.moveTo(top, left, width, height);
    }

    D3CategoriseView.prototype.moveTo = function(top, left, width, height) {
        this.valueScale = d3.scale.linear()
            .domain([0, 3])
            .range([0, width])
            .clamp(true);

        this.riskScale = d3.scale.linear()
            .domain([0, 4])
            .range([0, height])
            .clamp(true);

        this.brush = d3.svg.brush()
            .x(this.valueScale)
            .y(this.riskScale)
            .on("brushstart", this.brushstart(this))
            .on("brush", this.brush(this))
            .on("brushend", this.brushend(this));

        this.svg = d3.select("svg");

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

        var cardIdentity = function(d) { return d.id(); };

        var existingCards = this.svg.selectAll("circle.card")
            .data(cards, cardIdentity);

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
            d3.select("text#text" + d.shortId())
                .attr("x", function(d) { return d.x; })
                .attr("y", function(d) { return d.y; });
        }

        existingCards.each(updateCardClasses);

        var newCards = existingCards.enter();

        var newCardCircles = newCards
          .append("circle")
            .attr("class", "card")
            .attr("r", self.maxRadius)
            .call(drag);

        newCardCircles
          .append("title")
            .text(function(c) { return c.name(); });

        newCardCircles
            .attr("cx", function(d) {
                return self.clampX(self.valueScale(3));
            })
            .attr("cy", function(d) {
                return d.y = d.y || self.clampY(self.riskScale(3 + Math.random()));
            })
            .transition()
                .duration(500)
                .attr("cx", function(d) {
                    return d.x = d.x || self.clampX(self.valueScale(3 - (3 * d.fractionThroughList)));
                });

        d3.selectAll("circle.card")
            .on("mouseover", function(c) {
                c.highlighted(true);
                d3.select(this).classed("highlighted", true);
            })
            .on("mouseout", function(c) {
                c.highlighted(false);
                d3.select(this).classed("highlighted", false);
            });

        existingCards.exit()
            .transition()
                .duration(200)
                .style("opacity", 0)
                .duration(250)
                .attr("cy", function(d) {
                    return self.riskScale(4);
                })
            .remove();

        this.svg.selectAll("text.card").remove();

        var allShortIds = this.svg.selectAll("text.card")
            .data(cards);

        allShortIds.enter().append("text")
            .attr("class", "card")
            .attr("id", function(d) { return "text" + d.shortId(); })
            .attr("x", function(d) { return d.x; })
            .attr("y", function(d) { return d.y; })
            .attr("text-anchor","middle")
            .text(function(d) { return d.shortId(); });

        allShortIds.exit().remove();
    }

    global.D3CategoriseView = D3CategoriseView;
})(jQuery, d3, window);