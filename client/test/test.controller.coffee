angular.module 'mauiTestApp', []

.run () ->
  console.debug 'mauiTestApp'

.controller 'TestCtrl', (
  $scope
) ->

  angular.extend $scope,
    message: 'hello test...'



