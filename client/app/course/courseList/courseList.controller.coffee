angular.module('mauiApp')

.controller 'CourseListCtrl', (
  $scope
  $state
  $filter
  Restangular
) ->

  angular.extend $scope,
    courses: null

    pageConf:
      maxSize      : 5
      currentPage  : $state.params.page ? 1
      itemsPerPage : 12
      sort         : $state.params.sort
      keyword      : $state.params.keyword ? ''
      tags         : $filter('array')($state.params.tags)
      createdBy    : $state.params.createdBy
      category     : $state.params.category

    removeTag: (tag) ->
      $scope.pageConf.tags = _.without($scope.pageConf.tags, tag)
      $scope.reload()

    reload: (resetPageIndex) ->
      $scope.pageConf.currentPage = 1 if resetPageIndex
      $state.go 'courseList',
        page: $scope.pageConf.currentPage
        keyword: $scope.pageConf.keyword
        category: $scope.pageConf.category
        sort: $scope.pageConf.sort
        tags: $scope.pageConf.tags
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
        tags       : JSON.stringify $scope.pageConf.tags if _.isArray($scope.pageConf.tags)
        category   : $scope.pageConf.category
        createdBy  : $scope.pageConf.createdBy
      .then (courses)->
        $scope.courses = courses
        $scope.courseTotalCount = courses.$count

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

      $scope.$emit 'updateTitle', ->
        category = _.find($scope.categories, _id:$scope.pageConf.category)?.name
        title =
          if category
            "和#{category}相关的趣课"
          else
            '全部趣课'
        $scope.pageConf.tags.join('+') + title


