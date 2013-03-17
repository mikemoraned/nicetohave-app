// Generated by CoffeeScript 1.6.1
(function() {

  describe('PrivilegeLevel', function() {
    return describe('satisfies', function() {
      it('NONE', function() {
        expect(nicetohave.PrivilegeLevel.NONE.satisfies(nicetohave.PrivilegeLevel.NONE)).toBeTruthy();
        expect(nicetohave.PrivilegeLevel.NONE.satisfies(nicetohave.PrivilegeLevel.READ_ONLY)).toBeFalsy();
        return expect(nicetohave.PrivilegeLevel.NONE.satisfies(nicetohave.PrivilegeLevel.READ_WRITE)).toBeFalsy();
      });
      it('READ_ONLY', function() {
        expect(nicetohave.PrivilegeLevel.READ_ONLY.satisfies(nicetohave.PrivilegeLevel.NONE)).toBeTruthy();
        expect(nicetohave.PrivilegeLevel.READ_ONLY.satisfies(nicetohave.PrivilegeLevel.READ_ONLY)).toBeTruthy();
        return expect(nicetohave.PrivilegeLevel.READ_ONLY.satisfies(nicetohave.PrivilegeLevel.READ_WRITE)).toBeFalsy();
      });
      return it('READ_WRITE', function() {
        expect(nicetohave.PrivilegeLevel.READ_WRITE.satisfies(nicetohave.PrivilegeLevel.NONE)).toBeTruthy();
        expect(nicetohave.PrivilegeLevel.READ_WRITE.satisfies(nicetohave.PrivilegeLevel.READ_ONLY)).toBeTruthy();
        return expect(nicetohave.PrivilegeLevel.READ_WRITE.satisfies(nicetohave.PrivilegeLevel.READ_WRITE)).toBeTruthy();
      });
    });
  });

}).call(this);
