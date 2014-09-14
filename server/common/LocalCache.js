require('./init');
var Class = require('./Class').Class;

exports.LocalCache = Class.singleton({
    classname: 'LocalCache',

    $_cache: {},

    put: function(key, data) {
        this._cache[key] = {
            expire_at: _u.time() + 60,
            data: data,
        };
    },
    get: function(key) {
        var c = this._cache[key];
        if (!c) return null;
        if (c.expire_at < _u.time()) return null;

        return c.data;
    },
    delete: function(key) {
        delete this._cache[key];
    }
});
