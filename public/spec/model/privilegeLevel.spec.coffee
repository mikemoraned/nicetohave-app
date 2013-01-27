describe 'PrivilegeLevel', ->

  describe 'satisfies', ->

    it 'NONE', ->
      expect(nicetohave.PrivilegeLevel.NONE.satisfies(nicetohave.PrivilegeLevel.NONE)).toBeTruthy()
      expect(nicetohave.PrivilegeLevel.NONE.satisfies(nicetohave.PrivilegeLevel.READ_ONLY)).toBeFalsy()
      expect(nicetohave.PrivilegeLevel.NONE.satisfies(nicetohave.PrivilegeLevel.READ_WRITE)).toBeFalsy()

    it 'READ_ONLY', ->
      expect(nicetohave.PrivilegeLevel.READ_ONLY.satisfies(nicetohave.PrivilegeLevel.NONE)).toBeTruthy()
      expect(nicetohave.PrivilegeLevel.READ_ONLY.satisfies(nicetohave.PrivilegeLevel.READ_ONLY)).toBeTruthy()
      expect(nicetohave.PrivilegeLevel.READ_ONLY.satisfies(nicetohave.PrivilegeLevel.READ_WRITE)).toBeFalsy()

    it 'READ_WRITE', ->
      expect(nicetohave.PrivilegeLevel.READ_WRITE.satisfies(nicetohave.PrivilegeLevel.NONE)).toBeTruthy()
      expect(nicetohave.PrivilegeLevel.READ_WRITE.satisfies(nicetohave.PrivilegeLevel.READ_ONLY)).toBeTruthy()
      expect(nicetohave.PrivilegeLevel.READ_WRITE.satisfies(nicetohave.PrivilegeLevel.READ_WRITE)).toBeTruthy()