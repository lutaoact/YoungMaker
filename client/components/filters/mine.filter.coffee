angular.module('maui.components')

.filter 'mine', (Auth) ->
  (item, userId) ->
    label =
      if Auth.getCurrentUser()._id is userId
        '我的'
      else
        'TA的'
    item.replace('#mine#', label)
