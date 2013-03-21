describe 'Outstanding', ->

  describe 'normal usage', ->

    it 'count is zero on creation', ->
      outstanding = new nicetohave.Outstanding()

      expect(outstanding.count()).toEqual(0)

    it 'count is incremented on start', ->
      outstanding = new nicetohave.Outstanding()

      outstanding.started()

      expect(outstanding.count()).toEqual(1)

    it 'count is incremented on start of many', ->
      outstanding = new nicetohave.Outstanding()

      outstanding.started(13)

      expect(outstanding.count()).toEqual(13)

    it 'count is decremented on completed', ->
      outstanding = new nicetohave.Outstanding()

      outstanding.started(10)
      outstanding.completed()

      expect(outstanding.count()).toEqual(9)

    it 'count is decremented on completion of many', ->
      outstanding = new nicetohave.Outstanding()

      outstanding.started(13)
      outstanding.completed(10)

      expect(outstanding.count()).toEqual(3)

    it 'count goes back to zero', ->
      outstanding = new nicetohave.Outstanding()

      outstanding.started(13)
      outstanding.completed(13)

      expect(outstanding.count()).toEqual(0)

    it 'count can be reset even if not zero', ->
      outstanding = new nicetohave.Outstanding()

      outstanding.started(13)
      outstanding.reset()

      expect(outstanding.count()).toEqual(0)

  describe 'exceptional usage', ->

    it 'exception is thrown if completing more than started, when completing many', ->
      outstanding = new nicetohave.Outstanding()

      outstanding.started(13)

      expect(-> outstanding.completed(14)).toThrow({ message: "Completed is more than outstanding: 14 > 13" })

    it 'exception is thrown if completing more than started, when completing single', ->
      outstanding = new nicetohave.Outstanding()

      outstanding.started()
      outstanding.completed()

      expect(-> outstanding.completed()).toThrow({ message: "Completed is more than outstanding: 1 > 0" })

    it 'exception is thrown if started zero', ->
      outstanding = new nicetohave.Outstanding()

      expect(-> outstanding.started(0)).toThrow({ message: "Started is not >= 0: 0" })

    it 'exception is thrown if completed zero', ->
      outstanding = new nicetohave.Outstanding()

      outstanding.started(13)

      expect(-> outstanding.completed(0)).toThrow({ message: "Completed is not >= 0: 0" })

    it 'exception is thrown if started negative', ->
      outstanding = new nicetohave.Outstanding()

      expect(-> outstanding.started(-2)).toThrow({ message: "Started is not >= 0: -2" })

    it 'exception is thrown if completed negative', ->
      outstanding = new nicetohave.Outstanding()

      outstanding.started(13)

      expect(-> outstanding.completed(-2)).toThrow({ message: "Completed is not >= 0: -2" })