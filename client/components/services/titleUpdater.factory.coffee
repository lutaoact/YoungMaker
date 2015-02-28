angular.module 'maui.components'

.factory 'titleUpdater', ($rootScope, $window) ->

  initTitle = ''

  updateTitle = (title) ->
    $window.document.title = title

  resetTitle = ->
    updateTitle initTitle

  init: ->
    initTitle = $window.document.title
    $rootScope.$on 'updateTitle', (event, title) ->
      scope = event.targetScope
      if _.isFunction(title)
        scope?.$watch title, updateTitle
      else
        updateTitle(title)
      scope?.$on '$destroy', resetTitle
