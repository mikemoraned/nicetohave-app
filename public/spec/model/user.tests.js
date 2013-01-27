module("user: default status", {
    setup: function() {
        Trello.deauthorize();
    },

    teardown: function() {
        Trello.deauthorize();
    }
});

test( "create user", function() {
    var u = new nicetohave.User();

    equal(u.privileges(), nicetohave.Privilege.READ_ONLY);
});

module("user: priviliges", {
    setup: function() {
        Trello.deauthorize();
    },

    teardown: function() {
        Trello.deauthorize();
    }
});

asyncTest( "get read-write priviliges", function() {
    var u = new nicetohave.User();

    var called = 0;

    u.using(nicetohave.Privilege.READ_WRITE, function() {
        called += 1;
        start();
    });

    equal(called, 1);
    equal(u.privileges(), nicetohave.Privilege.READ_WRITE);
});