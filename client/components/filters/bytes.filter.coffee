'use strict'

angular.module('maui.components')

.filter 'bytes', ->
  (bytes, precision) ->
    if isNaN(parseFloat(bytes)) || !isFinite(bytes) then return '-'
    precision = 1 if !precision?
    units = ['bytes', 'kb', 'MB', 'GB', 'TB', 'PB']
    number = Math.floor(Math.log(bytes) / Math.log(1024))
    (bytes / Math.pow(1024, Math.floor(number))).toFixed(precision) +  ' ' + units[number]
