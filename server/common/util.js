(function() {
  var arrayOmit, arrayPick, convertToCamelCase, convertToSnakeCase, findIndex, getModel, getUtils, milliseconds, time, union;

  require("./init");

  arrayPick = function(array, columns) {
    return _.map(array, function(element) {
      return _.pick.apply(_, [element].concat(columns));
    });
  };

  arrayOmit = function(array, columns) {
    return _.map(array, function(element) {
      return _.omit.apply(_, [element].concat(columns));
    });
  };

  time = function(date) {
    if (date) {
      return new Date(date).getTime() / 1000 | 0;
    } else {
      return new Date().getTime() / 1000 | 0;
    }
  };

  milliseconds = function() {
    return new Date().getTime();
  };

  convertToCamelCase = function(key) {
    return _.map(key.split("_"), function(s) {
      return s.charAt(0).toUpperCase() + s.substr(1);
    }).join("");
  };

  convertToSnakeCase = function(key) {
    return _.map(key.match(/[A-Z][a-z0-9]*/g), function(s) {
      return s.charAt(0).toLowerCase() + s.substr(1);
    }).join("_");
  };

  getModel = function(key) {
    return require("../api/" + key + "/" + key + ".model").Instance;
  };

  getUtils = function(key) {
    return require("../api/" + key + "/" + key + ".utils").Instance;
  };

  findIndex = function(array, key) {
    return _.findIndex(array, function(ele) {
      return ele.toString() === key;
    });
  };

  union = function() {
    return _.uniq(_.union.apply(_, arguments_), function(value) {
      return value.toString();
    });
  };

  exports.arrayPick = arrayPick;

  exports.arrayOmit = arrayOmit;

  exports.time = time;

  exports.milliseconds = milliseconds;

  exports.convertToCamelCase = convertToCamelCase;

  exports.convertToSnakeCase = convertToSnakeCase;

  exports.getModel = getModel;

  exports.getUtils = getUtils;

  exports.findIndex = findIndex;

  exports.union = union;

}).call(this);
