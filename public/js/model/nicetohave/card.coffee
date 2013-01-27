window.nicetohave ?= {}

class Card

  constructor: (id) ->
    if not /[a-z0-9]{24}/.test(id)
      throw { message: "Not a valid card id: '#{id}'" }

  name : ko.observable("")

window.nicetohave.Card = Card