describe 'Chooser', ->

  describe 'parsing', ->

    it 'will not parse a null string as an id', ->
      navigator = null
      chooser = new nicetohave.Chooser(navigator)
      expect(chooser.boardId()).toBeNull()

    it 'empty strings are not navigable', ->
      navigator = null
      chooser = new nicetohave.Chooser(navigator)
      chooser.boardUrl("")
      expect(chooser.navigable()).toBeFalsy()

    it 'invalid URLs are not navigable', ->
      navigator = null
      chooser = new nicetohave.Chooser(navigator)
      expect(chooser.navigable()).toBeFalsy()

    it 'will not parse any valid URL with an id', ->
      navigator = null
      chooser = new nicetohave.Chooser(navigator)
      chooser.boardUrl("https://foo.com/50d4b5faa5c6aadc4e001117")
      expect(chooser.boardId()).toBeNull()

    it 'will not parse a board id that is not long enough', ->
      navigator = null
      chooser = new nicetohave.Chooser(navigator)
      chooser.boardUrl("https://trello.com/board/nicetohave/50d4b5faa5c6aad1117")
      expect(chooser.boardId()).toBeNull()

    it 'will not parse a board id that is too long', ->
      navigator = null
      chooser = new nicetohave.Chooser(navigator)
      chooser.boardUrl("https://trello.com/board/nicetohave/50d4b5faa5c6aadc4e001117999")
      expect(chooser.boardId()).toBeNull()

    it 'will parse a full correctly formed board URL as an id', ->
      navigator = null
      chooser = new nicetohave.Chooser(navigator)
      chooser.boardUrl("https://trello.com/board/nicetohave/50d4b5faa5c6aadc4e001117")
      expect(chooser.boardId()).toEqual("50d4b5faa5c6aadc4e001117")

    it 'will tolerate leading space', ->
      navigator = null
      chooser = new nicetohave.Chooser(navigator)
      chooser.boardUrl("  https://trello.com/board/nicetohave/50d4b5faa5c6aadc4e001117")
      expect(chooser.boardId()).toEqual("50d4b5faa5c6aadc4e001117")

    it 'will tolerate trailing space', ->
      navigator = null
      chooser = new nicetohave.Chooser(navigator)
      chooser.boardUrl("https://trello.com/board/nicetohave/50d4b5faa5c6aadc4e001117   ")
      expect(chooser.boardId()).toEqual("50d4b5faa5c6aadc4e001117")

    it 'will tolerate leading and trailing space', ->
      navigator = null
      chooser = new nicetohave.Chooser(navigator)
      chooser.boardUrl("   https://trello.com/board/nicetohave/50d4b5faa5c6aadc4e001117   ")
      expect(chooser.boardId()).toEqual("50d4b5faa5c6aadc4e001117")

    it 'space-only URLs are not navigable', ->
      navigator = null
      chooser = new nicetohave.Chooser(navigator)
      chooser.boardUrl("    ")
      expect(chooser.navigable()).toBeFalsy()