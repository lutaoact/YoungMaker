require "./init"

#
# * @param  [Array] array   一个包含对象的数组
# * @param  [Array] columns 需要从对象中拣选出的属性名
# * @return [Array] 数组array的拷贝，其中的对象只包含columns中指定的那些列
# 
arrayPick = (array, columns) ->
  _.map array, (element) ->
    _.pick.apply _, [element].concat(columns)


#
# * @param  [Array] array   一个包含对象的数组
# * @param  [Array] columns 需要从对象中忽略的属性名
# * @return [Array] 数组array的拷贝，其中的对象不包含columns中指定的那些列
# 
arrayOmit = (array, columns) ->
  _.map array, (element) ->
    _.omit.apply _, [element].concat(columns)


#
# * @return [Integer] 当前的unix timestamp
# 
time = (date) ->
  if date
    new Date(date).getTime() / 1000 | 0
  else
    new Date().getTime() / 1000 | 0

#
# * @return [Integer] 当前的以毫秒为单位的时间戳
# 
milliseconds = ->
  new Date().getTime()

#
# * @param  [String] key 下划线分隔的字符串
# * @return [String] 每个单词首字母大写
# * @example user_card -> UserCard
# 
convertToCamelCase = (key) ->
  _.map(key.split("_"), (s) ->
    s.charAt(0).toUpperCase() + s.substr(1)
  ).join ""

#
# * @param  [String] key 每个单词首字母大写
# * @return [String] 下划线分隔
# * @example UserCard -> user_card
# 
convertToSnakeCase = (key) ->
  _.map(key.match(/[A-Z][a-z0-9]*/g), (s) ->
    s.charAt(0).toLowerCase() + s.substr(1)
  ).join "_"
getModel = (key) ->
  require("../api/" + key + "/" + key + ".model").Instance
getUtils = (key) ->
  require("../api/" + key + "/" + key + ".utils").Instance
findIndex = (array, key) ->
  _.findIndex array, (ele) ->
    ele.toString() is key

union = ->
  _.uniq _.union.apply(_, arguments_), (value) ->
    value.toString()

exports.arrayPick = arrayPick
exports.arrayOmit = arrayOmit
exports.time = time
exports.milliseconds = milliseconds
exports.convertToCamelCase = convertToCamelCase
exports.convertToSnakeCase = convertToSnakeCase
exports.getModel = getModel
exports.getUtils = getUtils
exports.findIndex = findIndex
exports.union = union
