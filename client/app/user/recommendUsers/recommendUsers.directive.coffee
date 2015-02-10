angular.module('mauiApp')

.factory 'RecommendsU', (Restangular)->
  currentPage = 1
  itemsPerPage = 3
  sortObj = {}
  sortObj.heat = -1
  sortObj.created = -1
  reload = () ->
    Restangular.all('users/recommends').getList
      from       : (currentPage - 1) * itemsPerPage
      limit      : itemsPerPage
      sort       : JSON.stringify sortObj

  recommendUsers =
    suggests: []
    change: ()->
      self = this
      self.loading = true
      reload()
      .then (courses)->
        self.suggests = courses
        if currentPage is Math.ceil(courses.$count / itemsPerPage)
          currentPage = 1
        else
          currentPage++
        self.loading = false

  recommendUsers.change()

  recommendUsers

.directive 'recommendUsers', (RecommendsU)->
  templateUrl: 'app/user/recommendUsers/recommendUsers.html'
  restrict: 'EA'
  replace: true
  link: (scope, element, attrs) ->

  controller: ($scope, Restangular, Auth)->
    angular.extend $scope,
      RecommendUsers: RecommendsU
