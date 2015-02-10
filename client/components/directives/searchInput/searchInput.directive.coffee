angular.module('maui.components')

.directive 'searchInput', ()->
  restrict: 'E'
  replace: true
  templateUrl: 'components/directives/searchInput/searchInput.html'
  scope:
    keyword: '='
    onSubmit: '&'
    placeholder: '@'

  controller: ($scope) ->

    angular.extend $scope,

      onSearch: ->
        $scope.onSubmit?($keyword:$scope.keyword)

      onKeyup: ($event) ->
        $scope.onSearch() if $event.keyCode is 13

      clear: ()->
        $scope.keyword = ''
        $scope.onSearch()

