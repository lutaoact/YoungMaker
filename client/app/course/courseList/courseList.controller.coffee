angular.module('mauiApp')

.factory 'RecommendCourses', (Restangular)->
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
      reload()
      .then (courses)->
        console.log courses
        self.suggests = courses
      currentPage++

  recommendCourses.change()

  recommendCourses


.controller 'CourseListCtrl', (
  Auth
  $scope
  $state
  Restangular
  notify
  RecommendCourses
) ->

  angular.extend $scope,
    courses: []

    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 6
      sort         : $state.params.sort
      keyword      : $state.params.keyword ? undefined
      tags         : if $state.params.tags then JSON.parse($state.params.tags) else []
      createdBy    : $state.params.createdBy
      category     : $state.params.category

    reload: (resetPageIndex) ->
      $scope.pageConf.currentPage = 1 if resetPageIndex
      $state.go 'courseList',
        page: $scope.pageConf.currentPage
        keyword: $scope.pageConf.keyword
        category: $scope.pageConf.category
        sort: $scope.pageConf.sort
        tags: JSON.stringify $scope.pageConf.tags if $scope.pageConf.tags?.length
        createdBy: $scope.pageConf.createdBy

    search: ()->
      sortObj = {}
      if $scope.pageConf.sort is 'heat'
        sortObj.heat = -1
        sortObj.viewersNum = -1
        sortObj.commentsNum = -1
        sortObj.created = -1
      else
        sortObj.created = -1

      Restangular.all('courses').getList
        from       : ($scope.pageConf.currentPage - 1) * $scope.pageConf.itemsPerPage
        limit      : $scope.pageConf.itemsPerPage
        keyword    : $scope.pageConf.keyword
        sort       : JSON.stringify sortObj
        tags       : JSON.stringify $scope.pageConf.tags if $scope.pageConf.tags?.length
        createdBy  : $scope.pageConf.createdBy
      .then (courses)->
        $scope.courses = courses
        $scope.courseTotalCount = courses.$count

    getCategoryName: (category)->
      if $scope.categories
        ($scope.categories.filter (x) -> x._id is category)?.name
      else
        ''

    RecommendCourses: RecommendCourses

  $scope.search()

  Restangular
  .all('categories')
  .getList()
  .then (categories) ->
    $scope.categories = categories
