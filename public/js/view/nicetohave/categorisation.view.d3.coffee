window.nicetohave ?= {}

class D3CategorisationView

  constructor: (@rootSelector, @width, @height) ->
    @maxRadius = 7
    @_setup()

  _setup: () =>
    @root = d3.select(@rootSelector)

    @valueScale = d3.scale.linear()
    .domain([0, 1])
    .range([0, @width])
    .clamp(true)

    @riskScale = d3.scale.linear()
    .domain([0, 1])
    .range([0, 0.75 * @height])
    .clamp(true)

    @uncategorisedScale = d3.scale.linear()
    .domain([0, 1])
    .range([0.75 * @height, @height])
    .clamp(true)

    self = @

    dragmove = (d) ->
#      d3.select(this)
#      .attr("cx", d.x = self._clampX(d3.event.x) )
#      .attr("cy", d.y = self._clampY(d3.event.y) )

    @drag = d3.behavior.drag().origin(Object).on("drag", dragmove)

  subscribeTo: (categorisations) =>
    @mapped = ko.computed(() =>
      categorisations().map(@_mappingForCategorisation)
    )
    @mapped.subscribe(@_updateDisplay)
    @_updateDisplay(@mapped())

  _mappingForCategorisation: (c) =>
    if c.fullyDefined()
      console.log("Fully defined")
      id: c.card.id()
      x: @valueScale(c.axis("value").value())
      y: @riskScale(c.axis("risk").value())
      card: c.card
    else
      console.log("Not defined")
      id: c.card.id()
      x: @valueScale(c.axis("value").value() or Math.random())
      y: @uncategorisedScale(Math.random())
      card: c.card

  _clampX: (x) =>
    Math.max(@maxRadius, Math.min(x, @width - @maxRadius))

  _clampY: (y) =>
    Math.max(@maxRadius, Math.min(y, @height - @maxRadius))

  _updateDisplay: (mapped) =>
    console.dir(mapped)

    existingCategorisations = @root.selectAll("circle.card").data(mapped, (d) => d.id)

    existingCategorisations
    .transition()
    .duration(200)
    .attr("cx", (d) => d.x)
    .attr("cy", (d) => d.y)
    .select("title")
    .text((d) -> return d.card.name())

    newCategorisations = existingCategorisations.enter()

    newCategorisationCircles = newCategorisations
    .append("circle")
    .attr("class", "card")
    .attr("r", @maxRadius)
    .call(@drag)

    newCategorisationCircles
    .append("title")
    .text((d) -> return d.card.name())

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