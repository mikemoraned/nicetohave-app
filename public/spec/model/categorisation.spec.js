// Generated by CoffeeScript 1.4.0
(function() {

  describe('Categorisation', function() {
    describe('loading from card', function() {
      it('when given card with no comments, has default categories', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(false);
        return expect(categorisation.axis("value").hasValue()).toEqual(false);
      });
      it('when given card with a single comment, with no assignment, has default categories', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments(new nicetohave.Comment("some random comment"));
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(false);
        return expect(categorisation.axis("value").hasValue()).toEqual(false);
      });
      it('when given card with a single comment, with an assignment to one axis, one is assigned, other is default', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("risk:0.5")]);
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.5);
        return expect(categorisation.axis("value").hasValue()).toEqual(false);
      });
      it('when given card with a single comment, with an assignment to both axes, both are assigned', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("risk:0.5 value:0.2")]);
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.5);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        return expect(categorisation.axis("value").value()).toEqual(0.2);
      });
      it('when given card with a single comment, with an assignment to both axes, but out of range, both are assigned max value', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("risk:20.5 value:1.2")]);
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(1.0);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        return expect(categorisation.axis("value").value()).toEqual(1.0);
      });
      it('when given card with a single comment, with an assignment to both axes, but mixed with guff, assigns to both', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("hello risk:0.2 some guff, blah value:0.3 chumley")]);
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.2);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        return expect(categorisation.axis("value").value()).toEqual(0.3);
      });
      it('when given card with a single comment, with an assignment to both axes, but in other order, assigns to both', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("value:0.3 risk:0.2")]);
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.2);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        return expect(categorisation.axis("value").value()).toEqual(0.3);
      });
      it('when given card with two comments, with an assignment to both axes, values are taken from latest comment', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("risk:0.2 value:0.1"), new nicetohave.Comment("risk:0.6 value:0.7")]);
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.2);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        return expect(categorisation.axis("value").value()).toEqual(0.1);
      });
      it('when given card with three comments, first and last with an assignment to both axes, values are taken from latest comment', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("risk:0.2 value:0.1"), new nicetohave.Comment("some other random crap"), new nicetohave.Comment("risk:0.6 value:0.7")]);
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.2);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        return expect(categorisation.axis("value").value()).toEqual(0.1);
      });
      it('when given card with three comments, middle only one with an assignment, values are taken from middle comment', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("some other random crap"), new nicetohave.Comment("risk:0.6 value:0.7"), new nicetohave.Comment("some other random crap")]);
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.6);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        return expect(categorisation.axis("value").value()).toEqual(0.7);
      });
      it('when card comments change, values are updated automatically from latest comments', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("risk:0.6 value:0.7")]);
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.6);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        expect(categorisation.axis("value").value()).toEqual(0.7);
        card.comments([new nicetohave.Comment("risk:0.2 value:0.1"), new nicetohave.Comment("risk:0.6 value:0.7")]);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.2);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        return expect(categorisation.axis("value").value()).toEqual(0.1);
      });
      return it('when an assignment to both axes is split across different comments, values are taken from both', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("risk:0.2"), new nicetohave.Comment("value:0.1")]);
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.2);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        return expect(categorisation.axis("value").value()).toEqual(0.1);
      });
    });
    describe('local edits', function() {
      it('when local edits made, and value is different, then this is regarded as a change', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("risk:0.6 value:0.7")]);
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.6);
        expect(categorisation.axis("risk").hasEdits()).toEqual(false);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        expect(categorisation.axis("value").value()).toEqual(0.7);
        expect(categorisation.axis("value").hasEdits()).toEqual(false);
        expect(categorisation.hasEdits()).toEqual(false);
        categorisation.axis("value").value(0.8);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.6);
        expect(categorisation.axis("risk").hasEdits()).toEqual(false);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        expect(categorisation.axis("value").value()).toEqual(0.8);
        expect(categorisation.axis("value").hasEdits()).toEqual(true);
        return expect(categorisation.hasEdits()).toEqual(true);
      });
      return it('when local edits made, and value is same, then this is not regarded as a change', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("risk:0.6 value:0.7")]);
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.6);
        expect(categorisation.axis("risk").hasEdits()).toEqual(false);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        expect(categorisation.axis("value").value()).toEqual(0.7);
        expect(categorisation.axis("value").hasEdits()).toEqual(false);
        expect(categorisation.hasEdits()).toEqual(false);
        categorisation.axis("value").value(0.7);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.6);
        expect(categorisation.axis("risk").hasEdits()).toEqual(false);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        expect(categorisation.axis("value").value()).toEqual(0.7);
        expect(categorisation.axis("value").hasEdits()).toEqual(false);
        return expect(categorisation.hasEdits()).toEqual(false);
      });
    });
    return describe('local edits followed by save', function() {
      it('when local edits made, and value is same, and save requested, then no comment is saved', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("risk:0.6 value:0.7")]);
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.6);
        expect(categorisation.axis("risk").hasEdits()).toEqual(false);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        expect(categorisation.axis("value").value()).toEqual(0.7);
        expect(categorisation.axis("value").hasEdits()).toEqual(false);
        expect(categorisation.hasEdits()).toEqual(false);
        categorisation.axis("value").value(0.7);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.6);
        expect(categorisation.axis("risk").hasEdits()).toEqual(false);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        expect(categorisation.axis("value").value()).toEqual(0.7);
        expect(categorisation.axis("value").hasEdits()).toEqual(false);
        expect(categorisation.hasEdits()).toEqual(false);
        expect(card.comments().length).toEqual(1);
        categorisation.saveEdits();
        return expect(card.comments().length).toEqual(1);
      });
      it('when local edits made, and value is different, and save requested, then a comment is saved containing changes', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("risk:0.6 value:0.7")]);
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.60);
        expect(categorisation.axis("risk").hasEdits()).toEqual(false);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        expect(categorisation.axis("value").value()).toEqual(0.70);
        expect(categorisation.axis("value").hasEdits()).toEqual(false);
        expect(categorisation.hasEdits()).toEqual(false);
        categorisation.axis("value").value(0.8);
        expect(categorisation.axis("risk").hasValue()).toEqual(true);
        expect(categorisation.axis("risk").value()).toEqual(0.6);
        expect(categorisation.axis("risk").hasEdits()).toEqual(false);
        expect(categorisation.axis("value").hasValue()).toEqual(true);
        expect(categorisation.axis("value").value()).toEqual(0.8);
        expect(categorisation.axis("value").hasEdits()).toEqual(true);
        expect(categorisation.hasEdits()).toEqual(true);
        expect(card.comments().length).toEqual(1);
        categorisation.saveEdits();
        expect(card.comments().length).toEqual(2);
        expect(card.comments()[0].text()).toEqual("value:0.8");
        return expect(categorisation.hasEdits()).toEqual(false);
      });
      it('when accepting edit, round to reasonable accuracy to stop knock-on serialised form being too verbose', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("risk:0.6 value:0.7")]);
        categorisation = new nicetohave.Categorisation(card);
        categorisation.axis("value").value(0.711111);
        categorisation.axis("risk").value(0.666666666);
        expect(categorisation.axis("risk").value()).toEqual(0.667);
        return expect(categorisation.axis("value").value()).toEqual(0.711);
      });
      return it('when reading comment, round to reasonable accuracy to be consistent with what we accept on edits', function() {
        var card, categorisation;
        card = new nicetohave.DummyCard();
        card.comments([new nicetohave.Comment("risk:0.666666666 value:0.711111")]);
        categorisation = new nicetohave.Categorisation(card);
        expect(categorisation.axis("risk").value()).toEqual(0.667);
        return expect(categorisation.axis("value").value()).toEqual(0.711);
      });
    });
  });

}).call(this);
