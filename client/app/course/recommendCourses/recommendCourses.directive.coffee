angular.module('mauiApp')

.factory 'RecommendsC', (Restangular)->
  currentPage = 1
  itemsPerPage = 3
  sortObj = {}
  sortObj.heat = -1
  sortObj.viewersNum = -1
  sortObj.commentsNum = -1
  sortObj.created = -1
  reload = () ->
    Restangular.all('courses').getList
      from       : (currentPage - 1) * itemsPerPage
      limit      : itemsPerPage
      sort       : JSON.stringify sortObj

  recommendCourses =
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

  recommendCourses.change()

  recommendCourses

.directive 'recommendCourses', (RecommendsC)->
  templateUrl: 'app/course/recommendCourses/recommendCourses.html'
  restrict: 'EA'
  replace: true
  link: (scope, element, attrs) ->

  controller: ($scope, Restangular, Auth)->
    angular.extend $scope,
      RecommendCourses: RecommendsC
