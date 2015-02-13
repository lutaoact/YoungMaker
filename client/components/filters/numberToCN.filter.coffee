
'use strict'

angular.module('maui.components')

.filter 'numberToCN', ->
  (number) ->

    ###
    # 单位
    ###

    units = '个十百千万@#%亿^&~'

    ###
    # 字符
    ###

    chars = '零一二三四五六七八九'
    a = (number + '').split('')
    s = []
    if a.length > 12
      throw new Error('too big')
    else
      i = 0
      j = a.length - 1
      while i <= j
        if j == 1 or j == 5 or j == 9
          # 两位数 处理特殊的 1*
          if i == 0
            if a[i] != '1'
              s.push chars.charAt(a[i])
          else
            s.push chars.charAt(a[i])
        else
          s.push chars.charAt(a[i])
        if i != j
          s.push units.charAt(j - i)
        i++
    # return s;
    s.join('').replace(/零([十百千万亿@#%^&~])/g, (m, d, b) ->
      # 优先处理 零百 零千 等
      b = units.indexOf(d)
      if b != -1
        if d == '亿'
          return d
        if d == '万'
          return d
        if a[j - b] == '0'
          return '零'
      ''
    ).replace(/零+/g, '零').replace(/零([万亿])/g, (m, b) ->
      # 零百 零千处理后 可能出现 零零相连的 再处理结尾为零的
      b
    ).replace(/亿[万千百]/g, '亿').replace(/[零]$/, '').replace(/[@#%^&~]/g, (m) ->
      {
        '@': '十'
        '#': '百'
        '%': '千'
        '^': '十'
        '&': '百'
        '~': '千'
      }[m]
    ).replace /([亿万])([一-九])/g, (m, d, b, c) ->
      c = units.indexOf(d)
      if c != -1
        if a[j - c] == '0'
          return d + '零' + b
      m
