// Generated by CoffeeScript 1.6.1
(function() {

  describe('Categorisation View', function() {
    describe('mapping to position', function() {
      it('should map fully categorised card to x, y position in main area', function() {
        var card, categorisation, mapped, view;
        card = new nicetohave.DummyCard("a-dummy-id");
        categorisation = new nicetohave.Categorisation(card);
        categorisation.axis("value").value(0.1);
        categorisation.axis("risk").value(0.5);
        view = new nicetohave.D3CategorisationView("svg", 200, 400, 1);
        mapped = view._mappingForCategorisation(categorisation);
        expect(mapped.x).toEqual(20.8);
        return expect(mapped.y).toEqual(150.125);
      });
      return it('should map fully uncategorised card to x, y position in uncategorised area', function() {
        var card, categorisation, mapped, view;
        card = new nicetohave.DummyCard("a-dummy-id");
        categorisation = new nicetohave.Categorisation(card);
        view = new nicetohave.D3CategorisationView("svg", 200, 400, 1);
        mapped = view._mappingForCategorisation(categorisation);
        expect(mapped.x).toBeGreaterThan(0);
        expect(mapped.x).toBeLessThan(200);
        expect(mapped.y).toBeGreaterThan(300);
        return expect(mapped.y).toBeLessThan(400);
      });
    });
    return describe('edits', function() {
      return it('categorised card that discards edits should return to uncategorised area', function() {
        var card, categorisation, mapped, view;
        card = new nicetohave.DummyCard("a-dummy-id");
        categorisation = new nicetohave.Categorisation(card);
        categorisation.axis("value").value(0.1);
        categorisation.axis("risk").value(0.5);
        view = new nicetohave.D3CategorisationView("svg", 200, 400, 1);
        mapped = view._mappingForCategorisation(categorisation);
        expect(mapped.x).toBeGreaterThan(0);
        expect(mapped.x).toBeLessThan(200);
        expect(mapped.y).toBeGreaterThan(0);
        expect(mapped.y).toBeLessThan(300);
        categorisation.discardEdits();
        mapped = view._mappingForCategorisation(categorisation);
        expect(mapped.x).toBeGreaterThan(0);
        expect(mapped.x).toBeLessThan(200);
        expect(mapped.y).toBeGreaterThan(300);
        return expect(mapped.y).toBeLessThan(400);
      });
    });
  });

}).call(this);