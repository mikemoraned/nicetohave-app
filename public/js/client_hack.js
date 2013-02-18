(function() {
    var opts = {"version": 1,"apiEndpoint": "https://api.trello.com","authEndpoint": "https://trello.com","key": "afaec27e30009b0b1cfb14d85f384ee1"};
    (function() {
        var h, v, w, j, x, y = [].slice;
        h = {};
        j = {};
        x = function(c, g) {
            var a;
            return null != j[c] ? g(j[c]) : (null != (a = h[c]) ? a : h[c] = []).push(g)
        };
        var clearAuthorization = function () {
            j.authorized = null;
        };
        w = function(c, g) {
            var a, f, d, z;
            j[c] = g;
            if (h[c]) {
                f = h[c];
                delete h[c];
                for (d = 0, z = f.length; d < z; d++)
                    a = f[d], a(g)
            }
        };
        v = function(c) {
            return "function" === typeof c
        };
        (function(c, g, a) {
            var f, d, h, j, A, k, o, l, B, t, e, p, q, r, i, s, m;
            k = a.key;
            e = a.token;
            d = a.apiEndpoint;
            h = a.authEndpoint;
            p = a.version;
            A = "" + d + "/" + p + "/";
            l = c.location;
            f = {version: function() {
                return p
            },key: function() {
                return k
            },setKey: function(b) {
                k =
                    b
            },token: function() {
                return e
            },setToken: function(b) {
                e = b
            },rest: function() {
                var b, c, u, n, f, d;
                c = arguments[0];
                b = 2 <= arguments.length ? y.call(arguments, 1) : [];
                d = B(b);
                n = d[0];
                u = d[1];
                f = d[2];
                b = d[3];
                a = {url: "" + A + n,type: c,data: {},dataType: "json",success: f,error: b};
                g.support.cors || (a.dataType = "jsonp", "GET" !== c && (a.type = "GET", g.extend(a.data, {_method: c})));
                k && (a.data.key = k);
                e && (a.data.token = e);
                null != u && g.extend(a.data, u);
                return g.ajax(a)
            },authorized: function() {
                return null != e
            },deauthorize: function() {
                clearAuthorization();
                e = null;
                q("token",
                    e)
            },authorize: function(b) {
                var d, f, n, h, i;
                a = g.extend(!0, {type: "redirect",persist: !0,interactive: !0,scope: {read: !0,write: !1,account: !1},expiration: "30days"}, b);
                b = /[&#]?token=([0-9a-f]{64})/;
                f = function() {
                    if (a.persist && null != e)
                        return q("token", e)
                };
                a.persist && null == e && (e = t("token"));
                null == e && (e = null != (i = b.exec(l.hash)) ? i[1] : void 0);
                if (this.authorized())
                    return f(), l.hash = l.hash.replace(b, ""), "function" === typeof a.success ? a.success() : void 0;
                if (!a.interactive)
                    return "function" === typeof a.error ? a.error() : void 0;
                n = function() {
                    var b, c;
                    b = a.scope;
                    c = [];
                    for (d in b)
                        (h = b[d]) && c.push(d);
                    return c
                }().join(",");
                switch (a.type) {
                    case "popup":
                        (function() {
                            var b, d, e, g;
                            x("authorized", function(b) {
                                return b ? (f(), "function" === typeof a.success ? a.success() : void 0) : "function" === typeof a.error ? a.error() : void 0
                            });
                            b = c.screenX + (c.innerWidth - 420) / 2;
                            e = c.screenY + (c.innerHeight - 470) / 2;
                            d = null != (g = /^[a-z]+:\/\/[^\/]*/.exec(l)) ? g[0] : void 0;
                            return c.open(j({return_url: d,callback_method: "postMessage",scope: n,expiration: a.expiration,name: a.name}),
                                "trello", "width=420,height=470,left=" + b + ",top=" + e)
                        })();
                        break;
                    default:
                        c.location = j({redirect_uri: l.href,callback_method: "fragment",scope: n,expiration: a.expiration,name: a.name})
                }
            }};
            m = ["GET", "PUT", "POST", "DELETE"];
            r = function(b) {
                return f[b.toLowerCase()] = function() {
                    return this.rest.apply(this, [b].concat(y.call(arguments)))
                }
            };
            for (i = 0, s = m.length; i < s; i++)
                d = m[i], r(d);
            f.del = f["delete"];
            m = "actions,cards,checklists,boards,lists,members,organizations,lists".split(",");
            r = function(b) {
                return f[b] = {get: function(a,
                                             c, d, e) {
                    return f.get("" + b + "/" + a, c, d, e)
                }}
            };
            for (i = 0, s = m.length; i < s; i++)
                d = m[i], r(d);
            c.Trello = f;
            j = function(b) {
                return h + "/" + p + "/authorize?" + g.param(g.extend({response_type: "token",key: k}, b))
            };
            B = function(b) {
                var a, c, d;
                c = b[0];
                a = b[1];
                d = b[2];
                b = b[3];
                v(a) && (b = d, d = a, a = {});
                c = c.replace(/^\/*/, "");
                return [c, a, d, b]
            };
            o = c.localStorage;
            null != o ? (t = function(b) {
                return o["trello_" + b]
            }, q = function(b, a) {
                return null === a ? delete o["trello_" + b] : o["trello_" + b] = a
            }) : t = q = function() {
            };
            "function" === typeof c.addEventListener && c.addEventListener("message",
                function(b) {
                    var a;
                    b.origin === h && (null != (a = b.source) && a.close(), e = null != b.data && 4 < b.data.length ? b.data : null, w("authorized", f.authorized()))
                }, !1)
        })(window, jQuery, opts)
    }).call(this);
})()