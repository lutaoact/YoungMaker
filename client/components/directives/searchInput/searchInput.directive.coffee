angular.module('maui.components')

.directive 'searchInput', ()->
  restrict: 'E'
  replace: true
  templateUrl: 'components/directives/searchInput/searchInput.html'
  scope:
    keyword: '='
    onSubmit: '&'
    placeholder: '@'

  controller: ($scope, $timeout) ->

    angular.extend $scope,

      submit: ->
        $scope.onSubmit?($keyword:$scope.keyword)

      clear: ->
        $scope.keyword = ''
        $timeout $scope.submit

