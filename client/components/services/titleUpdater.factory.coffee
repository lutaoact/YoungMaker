angular.module 'maui.components'

.factory 'titleUpdater', ($rootScope, $window) ->

  defaultTitle = ''

  # extra = defaultTitle if extra is true
  # extra = '杨梅客' if extra is null
  # document.title = title | extra
  updateTitle = (title, extra) ->
    title ?= defaultTitle
    title += ' | ' + extra if extra && extra isnt title
    $window.document.title = title

  resetTitle = ->
    updateTitle defaultTitle

  init: ->
    defaultTitle = $window.document.title
    # note: $scope.$emit 'updateTitle', title:String/Function, extra:Boolean/String
    $rootScope.$on 'updateTitle', (event, title, extra = '杨梅客 youngmakers.cn') ->
      scope = event.targetScope
      if _.isFunction(title)
        scope?.$watch title, (newTitle) ->
          updateTitle(newTitle, extra)
      else
        updateTitle(title, extra)
      scope?.$on '$destroy', resetTitle
