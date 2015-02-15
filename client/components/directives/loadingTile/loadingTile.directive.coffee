angular.module 'maui.components'

.directive 'loadingTile', ->

  restrict: 'EA'

  templateUrl: 'components/directives/loadingTile/loadingTile.html'

  scope:
    data: '='
    loadingText: '@' # icon class
    notFoundIcon: '@' # icon class
    notFoundText: '@'
