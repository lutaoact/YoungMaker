((_)->
  makeid = (length)->
    length ?= 6
    text = ""
    possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    [1..parseInt(length)].forEach ()->
      text += possible.charAt(Math.floor(Math.random() * possible.length))
    text
  _.getRandomStr = makeid
)(window||module)
