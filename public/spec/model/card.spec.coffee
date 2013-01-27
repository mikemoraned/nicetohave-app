describe 'Card', ->

  it 'has an empty name', ->
    card = new nicetohave.Card()
    expect(card.name()).toBe ""
