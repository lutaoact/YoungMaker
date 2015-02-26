angular.module('mauiApp')

.factory 'RecommendsA', (Restangular)->
  currentPage = 1
  itemsPerPage = 3
  sortObj = {}
  sortObj.heat = -1
  sortObj.viewersNum = -1
  sortObj.commentsNum = -1
  sortObj.created = -1
  reload = () ->
    Restangular.all('articles').getList
      from       : (currentPage - 1) * itemsPerPage
      limit      : itemsPerPage
      featured   : 'true'
      sort       : JSON.stringify sortObj

  recommendArticles =
    suggests: []
    change: ()->
      self = this
      self.loading = true
      reload()
      .then (articles)->
        self.suggests = articles
        if currentPage is Math.ceil(articles.$count / itemsPerPage)
          currentPage = 1
        else
          currentPage++
        self.loading = false

  recommendArticles.change()

  recommendArticles

.directive 'recommendArticles', (RecommendsA)->
  templateUrl: 'app/article/recommendArticles/recommendArticles.html'
  restrict: 'EA'
  replace: true
  link: (scope, element, attrs) ->

  controller: ($scope, Restangular, Auth)->
    angular.extend $scope,
      RecommendArticles: RecommendsA
