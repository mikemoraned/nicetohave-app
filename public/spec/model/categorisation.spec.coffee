describe 'Categorisation', ->

  describe 'loading from card', ->

    beforeEach ->

    it 'when given card with no comments, has default categories', ->
      privilege = new nicetohave.Privilege({})
      card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege)
      categorisation = new nicetohave.Categorisation(card)

      expect(categorisation.axis("risk").hasValue()).toEqual(false)
      expect(categorisation.axis("value").hasValue()).toEqual(false)

    it 'when given card with a single comment, with no assignment, has default categories', ->
      privilege = new nicetohave.Privilege({})
      card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege)
      card.comments(new nicetohave.Comment("some random comment"))
      categorisation = new nicetohave.Categorisation(card)

      expect(categorisation.axis("risk").hasValue()).toEqual(false)
      expect(categorisation.axis("value").hasValue()).toEqual(false)

    it 'when given card with a single comment, with an assignment to one axis, one is assigned, other is default', ->
      privilege = new nicetohave.Privilege({})
      card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege)
      card.comments([new nicetohave.Comment("risk:0.5")])
      categorisation = new nicetohave.Categorisation(card)

      expect(categorisation.axis("risk").hasValue()).toEqual(true)
      expect(categorisation.axis("risk").value()).toEqual(0.5)
      expect(categorisation.axis("value").hasValue()).toEqual(false)

    it 'when given card with a single comment, with an assignment to both axes, both are assigned', ->
      privilege = new nicetohave.Privilege({})
      card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege)
      card.comments([new nicetohave.Comment("risk:0.5 value:0.2")])
      categorisation = new nicetohave.Categorisation(card)

      expect(categorisation.axis("risk").hasValue()).toEqual(true)
      expect(categorisation.axis("risk").value()).toEqual(0.5)
      expect(categorisation.axis("value").hasValue()).toEqual(true)
      expect(categorisation.axis("value").value()).toEqual(0.2)

    it 'when given card with a single comment, with an assignment to both axes, but out of range, both are assigned max value', ->
      privilege = new nicetohave.Privilege({})
      card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege)
      card.comments([new nicetohave.Comment("risk:20.5 value:1.2")])
      categorisation = new nicetohave.Categorisation(card)

      expect(categorisation.axis("risk").hasValue()).toEqual(true)
      expect(categorisation.axis("risk").value()).toEqual(1.0)
      expect(categorisation.axis("value").hasValue()).toEqual(true)
      expect(categorisation.axis("value").value()).toEqual(1.0)

    it 'when given card with a single comment, with an assignment to both axes, but mixed with guff, assigns to both', ->
      privilege = new nicetohave.Privilege({})
      card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege)
      card.comments([new nicetohave.Comment("hello risk:0.2 some guff, blah value:0.3 chumley")])
      categorisation = new nicetohave.Categorisation(card)

      expect(categorisation.axis("risk").hasValue()).toEqual(true)
      expect(categorisation.axis("risk").value()).toEqual(0.2)
      expect(categorisation.axis("value").hasValue()).toEqual(true)
      expect(categorisation.axis("value").value()).toEqual(0.3)

    it 'when given card with a single comment, with an assignment to both axes, but in other order, assigns to both', ->
      privilege = new nicetohave.Privilege({})
      card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege)
      card.comments([new nicetohave.Comment("value:0.3 risk:0.2")])
      categorisation = new nicetohave.Categorisation(card)

      expect(categorisation.axis("risk").hasValue()).toEqual(true)
      expect(categorisation.axis("risk").value()).toEqual(0.2)
      expect(categorisation.axis("value").hasValue()).toEqual(true)
      expect(categorisation.axis("value").value()).toEqual(0.3)

    it 'when given card with a two comments, with an assignment to both axes, values are taken from latest comment', ->
      privilege = new nicetohave.Privilege({})
      card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege)
      card.comments([
        new nicetohave.Comment("risk:0.2 value:0.1"),
        new nicetohave.Comment("risk:0.6 value:0.7")
      ])
      categorisation = new nicetohave.Categorisation(card)

      expect(categorisation.axis("risk").hasValue()).toEqual(true)
      expect(categorisation.axis("risk").value()).toEqual(0.2)
      expect(categorisation.axis("value").hasValue()).toEqual(true)
      expect(categorisation.axis("value").value()).toEqual(0.1)

    it 'when given card with three comments, first and last with an assignment to both axes, values are taken from latest comment', ->
      privilege = new nicetohave.Privilege({})
      card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege)
      card.comments([
        new nicetohave.Comment("risk:0.2 value:0.1"),
        new nicetohave.Comment("some other random crap"),
        new nicetohave.Comment("risk:0.6 value:0.7")
      ])
      categorisation = new nicetohave.Categorisation(card)

      expect(categorisation.axis("risk").hasValue()).toEqual(true)
      expect(categorisation.axis("risk").value()).toEqual(0.2)
      expect(categorisation.axis("value").hasValue()).toEqual(true)
      expect(categorisation.axis("value").value()).toEqual(0.1)

    it 'when given card with three comments, middle only one with an assignment, values are taken from middle comment', ->
      privilege = new nicetohave.Privilege({})
      card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege)
      card.comments([
        new nicetohave.Comment("some other random crap"),
        new nicetohave.Comment("risk:0.6 value:0.7"),
        new nicetohave.Comment("some other random crap"),
      ])
      categorisation = new nicetohave.Categorisation(card)

      expect(categorisation.axis("risk").hasValue()).toEqual(true)
      expect(categorisation.axis("risk").value()).toEqual(0.6)
      expect(categorisation.axis("value").hasValue()).toEqual(true)
      expect(categorisation.axis("value").value()).toEqual(0.7)

    it 'when card comments change, values are updated automatically from latest comments', ->
      privilege = new nicetohave.Privilege({})
      card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege)
      card.comments([
        new nicetohave.Comment("risk:0.6 value:0.7")
      ])
      categorisation = new nicetohave.Categorisation(card)

      expect(categorisation.axis("risk").hasValue()).toEqual(true)
      expect(categorisation.axis("risk").value()).toEqual(0.6)
      expect(categorisation.axis("value").hasValue()).toEqual(true)
      expect(categorisation.axis("value").value()).toEqual(0.7)

      card.comments([
        new nicetohave.Comment("risk:0.2 value:0.1"),
        new nicetohave.Comment("risk:0.6 value:0.7")
      ])

      expect(categorisation.axis("risk").hasValue()).toEqual(true)
      expect(categorisation.axis("risk").value()).toEqual(0.2)
      expect(categorisation.axis("value").hasValue()).toEqual(true)
      expect(categorisation.axis("value").value()).toEqual(0.1)

    it 'when local edits made, and value is different, then this is regarded as a change', ->
      privilege = new nicetohave.Privilege({})
      card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege)
      card.comments([
        new nicetohave.Comment("risk:0.6 value:0.7")
      ])
      categorisation = new nicetohave.Categorisation(card)

      expect(categorisation.axis("risk").hasValue()).toEqual(true)
      expect(categorisation.axis("risk").value()).toEqual(0.6)
      expect(categorisation.axis("risk").hasEdits()).toEqual(false)

      expect(categorisation.axis("value").hasValue()).toEqual(true)
      expect(categorisation.axis("value").value()).toEqual(0.7)
      expect(categorisation.axis("value").hasEdits()).toEqual(false)

      categorisation.axis("value").value(0.8)
      console.log("Foop: #{categorisation.axis("value").value()}")

      expect(categorisation.axis("risk").hasValue()).toEqual(true)
      expect(categorisation.axis("risk").value()).toEqual(0.6)
      expect(categorisation.axis("risk").hasEdits()).toEqual(false)

      expect(categorisation.axis("value").hasValue()).toEqual(true)
      expect(categorisation.axis("value").value()).toEqual(0.8)
      expect(categorisation.axis("value").hasEdits()).toEqual(true)

    it 'when local edits made, and value is same, then this is not regarded as a change', ->
      privilege = new nicetohave.Privilege({})
      card = new nicetohave.Card("510557f3e002eb8d56002e04", privilege)
      card.comments([
        new nicetohave.Comment("risk:0.6 value:0.7")
      ])
      categorisation = new nicetohave.Categorisation(card)

      expect(categorisation.axis("risk").hasValue()).toEqual(true)
      expect(categorisation.axis("risk").value()).toEqual(0.6)
      expect(categorisation.axis("risk").hasEdits()).toEqual(false)

      expect(categorisation.axis("value").hasValue()).toEqual(true)
      expect(categorisation.axis("value").value()).toEqual(0.7)
      expect(categorisation.axis("value").hasEdits()).toEqual(false)

      categorisation.axis("value").value(0.7)

      expect(categorisation.axis("risk").hasValue()).toEqual(true)
      expect(categorisation.axis("risk").value()).toEqual(0.6)
      expect(categorisation.axis("risk").hasEdits()).toEqual(false)

      expect(categorisation.axis("value").hasValue()).toEqual(true)
      expect(categorisation.axis("value").value()).toEqual(0.7)
      expect(categorisation.axis("value").hasEdits()).toEqual(false)