window.nicetohave ?= {}

class D3CategorisationView

  constructor: (@rootSelector, @width, @height) ->
    @maxRadius = 7
    @_setup()

  subscribeTo: (categorisations) =>
    categorisations.subscribe(@_update)
    @_update(categorisations())

  _setup: () =>
    @root = d3.select(@rootSelector)

    @valueScale = d3.scale.linear()
    .domain([0, 3])
    .range([0, @width])
    .clamp(true)

    @riskScale = d3.scale.linear()
    .domain([0, 4])
    .range([0, @height])
    .clamp(true)

    self = @

    dragmove = (d) ->
      d3.select(this)
      .attr("cx", d.x = self._clampX(d3.event.x) )
      .attr("cy", d.y = self._clampY(d3.event.y) )

    @drag = d3.behavior.drag().origin(Object).on("drag", dragmove)

  _clampX: (x) =>
    Math.max(@maxRadius, Math.min(x, @width - @maxRadius))

  _clampY: (y) =>
    Math.max(@maxRadius, Math.min(y, @height - @maxRadius))

  _update: (categorisations) =>
    console.dir(categorisations)

    identity = (d) => d.card.id()

    existingCategorisations = @root.selectAll("circle.card").data(categorisations, identity)

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
    .attr("cx", (d) => @_clampX(@valueScale(3)))
    .attr("cy", (d) =>
      d.y = d.y || @_clampY(@riskScale(Math.random()))
    )
    .transition()
    .duration(500)
    .attr("cx", (d) =>
      d.x = d.x || @_clampX(@valueScale(Math.random()))
    )

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