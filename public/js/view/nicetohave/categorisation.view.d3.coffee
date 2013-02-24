window.nicetohave ?= {}

class D3CategorisationView

  constructor: (@width, @height) ->

  subscribeTo: (categorisations) =>
    categorisations.subscribe(@_update)
    @_update(categorisations())

  _update: (categorisations) =>
    console.dir(categorisations)

window.nicetohave.D3CategorisationView = D3CategorisationView