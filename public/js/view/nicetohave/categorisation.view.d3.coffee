window.nicetohave ?= {}

class D3CategorisationView

  constructor: (@rootSelector, @width, @height) ->
    @maxRadius = 7
    @_setup()

  _setup: () =>
    @root = d3.select(@rootSelector)

    @valueScale = d3.scale.linear()
    .domain([0, 1])
    .range([@maxRadius, @width - @maxRadius])
    .clamp(true)

    @riskScale = d3.scale.linear()
    .domain([0, 1])
    .range([@maxRadius, 0.75 * (@height - @maxRadius)])
    .clamp(true)

    @uncategorisedScale = d3.scale.linear()
    .domain([0, 1])
    .range([0.75 * (@height - @maxRadius), @height - @maxRadius])
    .clamp(true)

    self = @

    dragmove = (d) ->
      d3.select(this)
      .attr("cx", d.x = self._clampX(d3.event.x) )
      .attr("cy", d.y = self._clampY(d3.event.y) )

    dragend = (d) =>
      d.cat.axis("value").value(@valueScale.invert(d.x))
      d.cat.axis("risk").value(@riskScale.invert(d.y))

    @drag = d3.behavior.drag().origin(Object).on("drag", dragmove).on("dragend", dragend)

  subscribeTo: (categorisations) =>
    @mapped = ko.computed(() =>
      categorisations().map(@_mappingForCategorisation)
    )
    @mapped.subscribe(@_updateDisplay)
    @_updateDisplay(@mapped())

  _mappingForCategorisation: (c) =>
    if c.fullyDefined()
      id: c.card.id()
      x: @valueScale(c.axis("value").value())
      y: @riskScale(c.axis("risk").value())
      cat: c
    else
      id: c.card.id()
      x: @valueScale(c.axis("value").value() or Math.random())
      y: @uncategorisedScale(Math.random())
      cat: c

  _clampX: (x) =>
    Math.max(@maxRadius, Math.min(x, @width - @maxRadius))

  _clampY: (y) =>
    Math.max(@maxRadius, Math.min(y, @height - @maxRadius))

  _updateDisplay: (mapped) =>
    existingCategorisations = @root.selectAll("circle.card").data(mapped, (d) => d.id)

    existingCategorisations
    .transition()
    .duration(200)
    .attr("cx", (d) => d.x)
    .attr("cy", (d) => d.y)
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
    .attr("cx", (d) => d.x)
    .attr("cy", (d) => d.y)

    existingCategorisations.exit()
    .transition()
    .duration(200)
    .style("opacity", 0)
    .duration(250)
    .attr("cy", (d) =>
      @riskScale(4)
    )
    .remove()

window.nicetohave.D3CategorisationView = D3CategorisationView