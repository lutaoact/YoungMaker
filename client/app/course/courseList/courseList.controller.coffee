angular.module('mauiApp')

.controller 'CourseListCtrl', (
  Auth
  $scope
  $state
  Restangular
  notify
  $timeout
) ->

  getArray = (str)->
    if str.indexOf('[') > -1
      JSON.parse str
    else if str.indexOf(',') > -1
      str.split(',')
    else
      [str]

  angular.extend $scope,
    courses: null

    loading: true

    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 12
      sort         : $state.params.sort
      keyword      : $state.params.keyword ? undefined
      tags         : if $state.params.tags then getArray($state.params.tags) else []
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
        category   : $scope.pageConf.category
        createdBy  : $scope.pageConf.createdBy
      .then (courses)->
        $scope.courses = courses
        $scope.courseTotalCount = courses.$count
        $scope.loading = false
      , ->
        $scope.loading = false

    getCategoryName: (category)->
      if $scope.categories
        ($scope.categories.filter (x) -> x._id is category)?[0]?.name
      else
        ''
    getCategoryById: (categoryId)->
      if $scope.categories
        ($scope.categories.filter (x) -> x._id is categoryId)[0]
      else
        undefined

  $scope.search()

  Restangular
  .all('categories')
  .getList()
  .then (categories) ->
    $scope.categories = categories
