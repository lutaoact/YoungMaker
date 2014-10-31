require('./init');

/*
 * @param  [Array] array   一个包含对象的数组
 * @param  [Array] columns 需要从对象中拣选出的属性名
 * @return [Array] 数组array的拷贝，其中的对象只包含columns中指定的那些列
 */
function arrayPick(array, columns) {
    return _.map(array, function(element) {
        return _.pick.apply(_, [element].concat(columns));
    });
}
exports.arrayPick = arrayPick;

/*
 * @param  [Array] array   一个包含对象的数组
 * @param  [Array] columns 需要从对象中忽略的属性名
 * @return [Array] 数组array的拷贝，其中的对象不包含columns中指定的那些列
 */
function arrayOmit(array, columns) {
    return _.map(array, function(element) {
        return _.omit.apply(_, [element].concat(columns));
    });
}
exports.arrayOmit = arrayOmit;

/*
 * @return [Integer] 当前的unix timestamp
 */
function time(date) {
    if(date) {
        return new Date(date).getTime() / 1000 | 0;
    } else {
        return new Date().getTime() / 1000 | 0;
    }
}
exports.time = time;

/*
 * @return [Integer] 当前的以毫秒为单位的时间戳
 */
function milliseconds() {
    return new Date().getTime();
}
exports.milliseconds = milliseconds;

/*
 * @param  [String] key 下划线分隔的字符串
 * @return [String] 每个单词首字母大写
 * @example user_card -> UserCard
 */
function convertToCamelCase(key) {
    return _.map(key.split('_'), function(s) {
        return s.charAt(0).toUpperCase() + s.substr(1);
    }).join('');
}
exports.convertToCamelCase = convertToCamelCase;

/*
 * @param  [String] key 每个单词首字母大写
 * @return [String] 下划线分隔
 * @example UserCard -> user_card
 */
function convertToSnakeCase(key) {
    return _.map(key.match(/[A-Z][a-z0-9]*/g), function(s) {
        return s.charAt(0).toLowerCase() + s.substr(1);
    }).join('_');
}
exports.convertToSnakeCase = convertToSnakeCase;

function getModel(key) {
  return require('../api/' + key + '/' + key + '.model').Instance;
}
exports.getModel = getModel;

function getUtils(key) {
  return require('../api/' + key + '/' + key + '.utils').Instance;
}
exports.getUtils = getUtils;

function findIndex(array, key) {
  return _.findIndex(array, function(ele) {
    return ele.toString() === key;
  });
}
exports.findIndex = findIndex;

function union() {
  return _.uniq(_.union.apply(_, arguments), function(value) {
    return value.toString()
  });
}
exports.union = union;
