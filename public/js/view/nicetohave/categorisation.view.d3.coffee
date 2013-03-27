window.nicetohave ?= {}

class D3CategorisationView

  constructor: (@rootSelector, @width, @height, @cardWidth = 30, @cardHeight = 15) ->
    @maxRadius = Math.max(@cardWidth, @cardHeight) / 2.0
    @_setup()
    @_existingMappingForCategorisation = {}

  _setup: () =>
    @root = d3.select(@rootSelector)

    @_setupScales()
    @_setupDragBehaviour()
    @_setupTitleArea()
    @_resetUncategorisedArea()

  _setupScales: () =>
    @valueScale = d3.scale.linear()
    .domain([0, 1])
    .range([@cardWidth, @width - @cardWidth])
    .clamp(true)

    @riskScale = d3.scale.linear()
    .domain([0, 1])
    .range([@maxRadius, 0.75 * (@height - @maxRadius)])
    .clamp(true)

    @uncategorisedValueScale = @valueScale

    @uncategorisedRiskScale = d3.scale.linear()
    .domain([0, 1])
    .range([0.75 * (@height - @cardHeight), @height - @cardHeight])
    .clamp(true)

  _setupDragBehaviour: () =>
    self = @

    dragmove = (d) ->
      if d.cat.card.editable()
        d.x = self._clampX(d3.event.x)
        d.y = self._clampY(d3.event.y)
        d3.select(this)
          .attr("transform", "translate(#{d.x},#{d.y})" )

    dragend = (d) =>
      newValue = @valueScale.invert(d.x)
      newRisk = @riskScale.invert(d.y)
      d.cat.axis("value").value(newValue)
      d.cat.axis("risk").value(newRisk)

    @drag = d3.behavior.drag().origin(Object).on("drag", dragmove).on("dragend", dragend)

  _setupTitleArea: () =>
    @_titleAreaX = 0
    @_titleAreaY = (0.75 * @height)
    @_titleAreaHeight = 30
    @_inspected = ko.observable()

  _resetUncategorisedArea: () =>
    @_nextFreeSlot = 0

    @_nextFreeSlotXSpacing = @cardWidth * 1.1
    @_nextFreeSlotYSpacing = @cardWidth * 1.1
    @_nextFreeSlotXOffset = @cardWidth * 0.5
    @_nextFreeSlotYOffset = (0.75 * @height) + @_titleAreaHeight + @_nextFreeSlotYSpacing

    freeX = (@width - (@_nextFreeSlotXOffset * 2))
    @_cardsPerX = freeX / @_nextFreeSlotXSpacing

  subscribeTo: (categorisations) =>
    @mapped = ko.computed(() =>
      categorisations().map(@_mappingForCategorisation)
    ).extend({ throttle: 100 })
    @mapped.subscribe(@_updateDisplay)
    @_updateDisplay(@mapped())

    @_inspected.subscribe(@_updateTitleArea)
    @_updateTitleArea(@_inspected())

    @_resetUncategorisedArea()

  _mappingForCategorisation: (c) =>
    id = c.card.id()

    mapping = @_existingMappingForCategorisation[id]
    if not mapping?
      mapping = { id: id, cat: c }
      @_existingMappingForCategorisation[id] = mapping

    mapping.editable = c.card.editable()

    if c.fullyDefined()
      mapping.x = @valueScale(c.axis("value").value())
      mapping.y = @riskScale(c.axis("risk").value())
    else
      @_assignToUncategorisedSlot(mapping)
      mapping.x = mapping.uncategorisedX
      mapping.y = mapping.uncategorisedY

    mapping

  _assignToUncategorisedSlot: (mapping) =>
    if not mapping.uncategorisedSlot?
      mapping.uncategorisedSlot = @_nextFreeSlot
      mapping.uncategorisedX = ((@_nextFreeSlot % @_cardsPerX) * @_nextFreeSlotXSpacing) + @_nextFreeSlotXOffset
      mapping.uncategorisedY = (Math.floor(@_nextFreeSlot / @_cardsPerX) * @_nextFreeSlotYSpacing) + @_nextFreeSlotYOffset
      @_nextFreeSlot++

  _clampX: (x) =>
    Math.max(@maxRadius, Math.min(x, @width - @maxRadius))

  _clampY: (y) =>
    Math.max(@maxRadius, Math.min(y, @height - @maxRadius))

  _updateDisplay: (mapped) =>
    existing = @root.selectAll("g.mini-card")
                    .data(mapped, (d) => d.id)

    existing
    .classed("editable", (d) => d.cat.card.editable())
    .transition()
      .duration(200)
      .attr("transform", (d) => "translate(#{d.x},#{d.y})" )

    theNew = existing.enter()
    .append("g")
    .classed("mini-card", true)
    .classed("editable", (d) => d.cat.card.editable())
    .attr("transform", (d) => "translate(#{d.x},#{d.y})" )
    .call(@drag)
    .on("mouseover", (d) => @_inspected(d.cat.card))
    .on("mouseout", (d) => @_inspected(null))

    theNew.append("rect")
    .attr("width", @cardWidth)
    .attr("height", @cardHeight)
    .attr("rx", 5)
    .attr("ry", 5)

    existing.exit()
    .transition()
    .duration(200)
    .style("opacity", 0)
    .remove()

  _updateTitleArea: (inspected) =>
    data = if inspected? then [inspected] else []
    existingTitles = @root.selectAll("text.title")
                          .data(data, (d) => d.id)
    existingTitles.text((d) -> d.name())

    newTitles = existingTitles.enter()

    newTitles.append("text")
    .attr("x", @_titleAreaX)
    .attr("y", @_titleAreaY)
    .attr("transform", "translate(0,#{0.85 * @_titleAreaHeight})")
    .classed("title", true)
    .text((d) -> d.name())

    existingTitles.exit()
    .remove()

window.nicetohave.D3CategorisationView = D3CategorisationView