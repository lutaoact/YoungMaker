'use strict'

angular.module('maui.components')

.directive 'embeded', ($filter ,$timeout)->
  restrict: 'C'
  link: (scope, element, attrs)->
    timeoutPromise = null
    attrs.$observe 'title', (value)->
      element.addClass('busy')
      $timeout.cancel(timeoutPromise)
      if value
        console.log value
        timeoutPromise = $timeout ()->
          element.removeClass('busy')
          content = $filter('embed')(value)?.toString() || ''
          element.html(content)
        , 1500
      else
        element.removeClass('busy')
        element.html('')
.controller 'MagicPopupCtrl', (
  $scope
  $modalInstance
) ->
  angular.extend $scope,
    embededcode: ''
    close: (result) ->
      if result
        content = $('#embeded-preview').html()
        if content
          result = """<div class="embeded" title="#{result}">#{content}</div>"""
          $modalInstance.close(result)
        else
          alert('还未加载完成，请等待片刻')
      else
        $modalInstance.dismiss('cancel')
