describe 'Categorisation View', ->

  describe 'mapping to position', ->

    it 'should map fully categorised card to x, y position in main area', ->
      card = new nicetohave.DummyCard("a-dummy-id")
      categorisation = new nicetohave.Categorisation(card)

      categorisation.axis("value").value(0.1)
      categorisation.axis("risk").value(0.5)

      view = new nicetohave.D3CategorisationView("svg", 200, 400, 0)

      mapped = view._mappingForCategorisation(categorisation)

      expect(mapped.x).toEqual(20)
      expect(mapped.y).toEqual(150)

    it 'should map fully uncategorised card to x, y position in uncategorised area', ->
      card = new nicetohave.DummyCard("a-dummy-id")
      categorisation = new nicetohave.Categorisation(card)

      view = new nicetohave.D3CategorisationView("svg", 200, 400, 0)

      mapped = view._mappingForCategorisation(categorisation)

      expect(mapped.x).toBeGreaterThan(0)
      expect(mapped.x).toBeLessThan(200)
      expect(mapped.y).toBeGreaterThan(300)
      expect(mapped.y).toBeLessThan(400)
