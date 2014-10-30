'use strict'

if typeof String.prototype.startsWith isnt 'function'
  String.prototype.startsWith = (prefix)->
    this.slice(0, prefix.length) is prefix

if typeof String.prototype.endsWith isnt 'function'
  String.prototype.endsWith = (suffix) ->
    this.slice(-suffix.length) is suffix
