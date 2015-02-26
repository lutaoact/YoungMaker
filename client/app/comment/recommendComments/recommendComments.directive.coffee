angular.module('mauiApp')

.factory 'RecommendsCm', (Restangular)->
  currentPage = 1
  itemsPerPage = 3
  sortObj = {}
  sortObj.heat = -1
  sortObj.likeUsers = -1
  sortObj.created = -1
  reload = () ->
    Restangular.all('comments').getList
      from       : (currentPage - 1) * itemsPerPage
      limit      : itemsPerPage
      sort       : JSON.stringify sortObj
      type       : Const.CommentType.Article

  recommendComments =
    suggests: []
    change: ()->
      self = this
      self.loading = true
      reload()
      .then (comments)->
        console.log comments
        self.suggests = comments
        if currentPage is Math.ceil(comments.$count / itemsPerPage)
          currentPage = 1
        else
          currentPage++
        self.loading = false

  recommendComments.change()

  recommendComments

.directive 'recommendComments', (RecommendsCm)->
  templateUrl: 'app/comment/recommendComments/recommendComments.html'
  restrict: 'EA'
  replace: true
  link: (scope, element, attrs) ->

  controller: ($scope, Restangular, Auth)->
    angular.extend $scope,
      RecommendComments: RecommendsCm
