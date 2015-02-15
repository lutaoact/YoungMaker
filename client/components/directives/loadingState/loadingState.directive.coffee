angular.module 'maui.components'

.directive 'loadingState', ->

  restrict: 'EA'

  templateUrl: 'components/directives/loadingState/loadingState.html'

  scope:
    data: '='
    loadingText: '@' # icon class
    notFoundIcon: '@' # icon class
    notFoundText: '@'
