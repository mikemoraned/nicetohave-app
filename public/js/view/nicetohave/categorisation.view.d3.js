// Generated by CoffeeScript 1.6.1
(function() {
  var D3CategorisationView, _ref,
    _this = this;

  if ((_ref = window.nicetohave) == null) {
    window.nicetohave = {};
  }

  D3CategorisationView = (function() {

    function D3CategorisationView(outstanding, rootSelector, width, height, cardWidth, cardHeight) {
      var _this = this;
      this.outstanding = outstanding;
      this.rootSelector = rootSelector;
      this.width = width;
      this.height = height;
      this.cardWidth = cardWidth != null ? cardWidth : 40;
      this.cardHeight = cardHeight != null ? cardHeight : 20;
      this._updateTitleArea = function(inspected) {
        return D3CategorisationView.prototype._updateTitleArea.apply(_this, arguments);
      };
      this._updateDisplay = function(mapped) {
        return D3CategorisationView.prototype._updateDisplay.apply(_this, arguments);
      };
      this._clampY = function(y) {
        return D3CategorisationView.prototype._clampY.apply(_this, arguments);
      };
      this._clampX = function(x) {
        return D3CategorisationView.prototype._clampX.apply(_this, arguments);
      };
      this._assignToUncategorisedSlot = function(mapping) {
        return D3CategorisationView.prototype._assignToUncategorisedSlot.apply(_this, arguments);
      };
      this._mappingForCategorisation = function(c) {
        return D3CategorisationView.prototype._mappingForCategorisation.apply(_this, arguments);
      };
      this.unsubscribeAll = function() {
        return D3CategorisationView.prototype.unsubscribeAll.apply(_this, arguments);
      };
      this.subscribeTo = function(categorisations) {
        return D3CategorisationView.prototype.subscribeTo.apply(_this, arguments);
      };
      this._setupProgressNotification = function() {
        return D3CategorisationView.prototype._setupProgressNotification.apply(_this, arguments);
      };
      this._resetUncategorisedArea = function() {
        return D3CategorisationView.prototype._resetUncategorisedArea.apply(_this, arguments);
      };
      this._setupTitleArea = function() {
        return D3CategorisationView.prototype._setupTitleArea.apply(_this, arguments);
      };
      this._setupDragBehaviour = function() {
        return D3CategorisationView.prototype._setupDragBehaviour.apply(_this, arguments);
      };
      this._setupScales = function() {
        return D3CategorisationView.prototype._setupScales.apply(_this, arguments);
      };
      this._setup = function() {
        return D3CategorisationView.prototype._setup.apply(_this, arguments);
      };
      this.maxRadius = Math.max(this.cardWidth, this.cardHeight) / 2.0;
      this._setup();
      this._existingMappingForCategorisation = {};
    }

    D3CategorisationView.prototype._setup = function() {
      this.root = d3.select(this.rootSelector);
      this.container = this.root.select("g.container");
      this._setupScales();
      this._setupDragBehaviour();
      this._setupTitleArea();
      this._resetUncategorisedArea();
      return this._setupProgressNotification();
    };

    D3CategorisationView.prototype._setupScales = function() {
      this.valueScale = d3.scale.linear().domain([0, 1]).range([this.cardWidth, this.width - this.cardWidth]).clamp(true);
      this.riskScale = d3.scale.linear().domain([0, 1]).range([this.maxRadius, 0.75 * (this.height - this.maxRadius)]).clamp(true);
      this.uncategorisedValueScale = this.valueScale;
      return this.uncategorisedRiskScale = d3.scale.linear().domain([0, 1]).range([0.75 * (this.height - this.cardHeight), this.height - this.cardHeight]).clamp(true);
    };

    D3CategorisationView.prototype._setupDragBehaviour = function() {
      var dragend, dragmove, self,
        _this = this;
      self = this;
      dragmove = function(d) {
        if (d.cat.card.editable()) {
          d.x = self._clampX(d3.event.x);
          d.y = self._clampY(d3.event.y);
          return d3.select(this).attr("transform", "translate(" + d.x + "," + d.y + ")");
        }
      };
      dragend = function(d) {
        var newRisk, newValue;
        newValue = _this.valueScale.invert(d.x);
        newRisk = _this.riskScale.invert(d.y);
        d.cat.axis("value").value(newValue);
        return d.cat.axis("risk").value(newRisk);
      };
      return this.drag = d3.behavior.drag().origin(Object).on("drag", dragmove).on("dragend", dragend);
    };

    D3CategorisationView.prototype._setupTitleArea = function() {
      this._titleAreaX = 0;
      this._titleAreaY = 0.75 * this.height;
      this._titleAreaHeight = 30;
      return this._inspected = ko.observable();
    };

    D3CategorisationView.prototype._resetUncategorisedArea = function() {
      var freeX;
      this._nextFreeSlot = 0;
      this._nextFreeSlotXSpacing = this.cardWidth * 1.1;
      this._nextFreeSlotYSpacing = this.cardWidth * 1.1;
      this._nextFreeSlotXOffset = this.cardWidth * 0.5;
      this._nextFreeSlotYOffset = (0.75 * this.height) + this._titleAreaHeight + this._nextFreeSlotYSpacing;
      freeX = this.width - (this._nextFreeSlotXOffset * 2);
      return this._cardsPerX = freeX / this._nextFreeSlotXSpacing;
    };

    D3CategorisationView.prototype._setupProgressNotification = function() {
      var _this = this;
      this.shouldBlockUI = ko.computed(function() {
        return _this.outstanding.count() > 0;
      });
      return this.shouldBlockUI.subscribe(function(shouldBlockUI) {
        console.log("shouldBlockUI: " + shouldBlockUI);
        return _this.root.selectAll(".busy").classed("hide", !shouldBlockUI);
      });
    };

    D3CategorisationView.prototype.subscribeTo = function(categorisations) {
      var _this = this;
      this.mapped = ko.computed(function() {
        return categorisations().map(_this._mappingForCategorisation);
      }).extend({
        throttle: 100
      });
      this.mapped.subscribe(this._updateDisplay);
      this._updateDisplay(this.mapped());
      this._inspected.subscribe(this._updateTitleArea);
      this._updateTitleArea(this._inspected());
      return this._resetUncategorisedArea();
    };

    D3CategorisationView.prototype.unsubscribeAll = function() {
      this.mapped = ko.observableArray();
      this._updateDisplay(this.mapped());
      return this._resetUncategorisedArea();
    };

    D3CategorisationView.prototype._mappingForCategorisation = function(c) {
      var id, mapping;
      id = c.card.id();
      mapping = this._existingMappingForCategorisation[id];
      if (mapping == null) {
        mapping = {
          id: id,
          cat: c
        };
        this._existingMappingForCategorisation[id] = mapping;
      }
      mapping.editable = c.card.editable();
      if (c.fullyDefined()) {
        mapping.x = this.valueScale(c.axis("value").value());
        mapping.y = this.riskScale(c.axis("risk").value());
      } else {
        this._assignToUncategorisedSlot(mapping);
        mapping.x = mapping.uncategorisedX;
        mapping.y = mapping.uncategorisedY;
      }
      return mapping;
    };

    D3CategorisationView.prototype._assignToUncategorisedSlot = function(mapping) {
      if (mapping.uncategorisedSlot == null) {
        mapping.uncategorisedSlot = this._nextFreeSlot;
        mapping.uncategorisedX = ((this._nextFreeSlot % this._cardsPerX) * this._nextFreeSlotXSpacing) + this._nextFreeSlotXOffset;
        mapping.uncategorisedY = (Math.floor(this._nextFreeSlot / this._cardsPerX) * this._nextFreeSlotYSpacing) + this._nextFreeSlotYOffset;
        return this._nextFreeSlot++;
      }
    };

    D3CategorisationView.prototype._clampX = function(x) {
      return Math.max(this.maxRadius, Math.min(x, this.width - this.maxRadius));
    };

    D3CategorisationView.prototype._clampY = function(y) {
      return Math.max(this.maxRadius, Math.min(y, this.height - this.maxRadius));
    };

    D3CategorisationView.prototype._updateDisplay = function(mapped) {
      var existing, theNew,
        _this = this;
      existing = this.container.selectAll("g.mini-card").data(mapped, function(d) {
        return d.id;
      });
      existing.classed("editable", function(d) {
        return d.cat.card.editable();
      }).transition().duration(200).attr("transform", function(d) {
        return "translate(" + d.x + "," + d.y + ")";
      });
      existing.selectAll("text").text(function(d) {
        return d.cat.card.idShort();
      });
      theNew = existing.enter().append("g").classed("mini-card", true).classed("editable", function(d) {
        return d.cat.card.editable();
      }).attr("transform", function(d) {
        return "translate(" + d.x + "," + d.y + ")";
      }).call(this.drag).on("mouseover", function(d) {
        return _this._inspected(d.cat.card);
      }).on("mouseout", function(d) {
        return _this._inspected(null);
      });
      theNew.append("rect").attr("width", this.cardWidth).attr("height", this.cardHeight).attr("rx", 5).attr("ry", 5);
      theNew.append("text").attr("transform", "translate(5,15)").text(function(d) {
        return d.cat.card.idShort();
      });
      return existing.exit().transition().duration(200).style("opacity", 0).remove();
    };

    D3CategorisationView.prototype._updateTitleArea = function(inspected) {
      var data, existingTitles, newTitles,
        _this = this;
      data = inspected != null ? [inspected] : [];
      existingTitles = this.container.selectAll("text.title").data(data, function(d) {
        return d.id;
      });
      existingTitles.text(function(d) {
        return d.idShort() + ": " + d.name();
      });
      newTitles = existingTitles.enter();
      newTitles.append("text").attr("x", this._titleAreaX).attr("y", this._titleAreaY).attr("transform", "translate(0," + (0.85 * this._titleAreaHeight) + ")").classed("title", true).text(function(d) {
        return d.idShort() + ": " + d.name();
      });
      return existingTitles.exit().remove();
    };

    return D3CategorisationView;

  })();

  window.nicetohave.D3CategorisationView = D3CategorisationView;

}).call(this);
