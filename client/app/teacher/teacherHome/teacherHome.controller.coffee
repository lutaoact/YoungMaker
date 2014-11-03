'use strict'

angular.module('mauiApp').controller 'TeacherHomeCtrl', (
  Auth
  $modal
  $state
  $scope
) ->

  angular.extend $scope,

    sayHello: ->
      console.debug 'hello teacher.'

  $scope.sayHello()
