window.nicetohave ?= {}

class D3CategorisationView

  constructor: (@rootSelector, @width, @height, @maxRadius = 10) ->
    @_setup()
    @_existingMappingForCategorisation = {}

  _setup: () =>
    @root = d3.select(@rootSelector)

    @_setupScales()
    @_setupDragBehaviour()
    @_resetUncategorisedArea()

  _setupScales: () =>
    @valueScale = d3.scale.linear()
    .domain([0, 1])
    .range([@maxRadius, @width - @maxRadius])
    .clamp(true)

    @riskScale = d3.scale.linear()
    .domain([0, 1])
    .range([@maxRadius, 0.75 * (@height - @maxRadius)])
    .clamp(true)

    @uncategorisedValueScale = @valueScale

    @uncategorisedRiskScale = d3.scale.linear()
    .domain([0, 1])
    .range([0.75 * (@height - @maxRadius), @height - @maxRadius])
    .clamp(true)

  _setupDragBehaviour: () =>
    self = @

#    dragmove = (d) ->
#      d3.select(this)
#      .attr("cx", d.x = self._clampX(d3.event.x) )
#      .attr("cy", d.y = self._clampY(d3.event.y) )

    dragmove = (d) ->
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

  _resetUncategorisedArea: () =>
    @_nextFreeSlot = 0

    @_nextFreeSlotXSpacing = @maxRadius * 2.5
    @_nextFreeSlotYSpacing = @_nextFreeSlotXSpacing
    @_nextFreeSlotXOffset = @maxRadius * 1.5
    @_nextFreeSlotYOffset = (0.75 * @height) + @_nextFreeSlotYSpacing

    freeX = (@width - (@_nextFreeSlotXOffset * 2))
    @_cardsPerX = freeX / @_nextFreeSlotXSpacing

  subscribeTo: (categorisations) =>
    @mapped = ko.computed(() =>
      categorisations().map(@_mappingForCategorisation)
    )
    @mapped.subscribe(@_updateDisplay)
    @_updateDisplay(@mapped())
    @_resetUncategorisedArea()

  _mappingForCategorisation: (c) =>
    id = c.card.id()

    mapping = @_existingMappingForCategorisation[id]
    if not mapping?
      mapping = { id: id, cat: c }
      @_existingMappingForCategorisation[id] = mapping

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
    existingCategorisations = @root.selectAll("circle.card")
                                   .data(mapped, (d) => d.id)

    existingCategorisations
    .transition()
      .duration(200)
      .attr("transform", (d) => "translate(#{d.x},#{d.y})" )
#      .attr("cx", (d) => d.x)
#      .attr("cy", (d) => d.y)
      .select("title")
      .text((d) -> return d.cat.card.name())

    newCategorisations = existingCategorisations.enter()

    newCategorisationCircles = newCategorisations
    .append("circle")
    .attr("class", "card")
    .attr("r", @maxRadius)
    .call(@drag)

    newCategorisationCircles
    .append("title")
    .text((d) -> return d.cat.card.name())

    newCategorisationCircles
    .attr("transform", (d) => "translate(#{d.x},#{d.y})" )
#    .attr("cx", (d) => d.x)
#    .attr("cy", (d) => d.y)

    existingCategorisations.exit()
    .transition()
    .duration(200)
    .style("opacity", 0)
    .duration(250)
    .attr("r", 0)
    .remove()

window.nicetohave.D3CategorisationView = D3CategorisationView