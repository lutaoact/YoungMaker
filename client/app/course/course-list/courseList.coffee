angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'courseList',
    url: '/courses'
    templateUrl: 'app/course/course-list/course-list.html'
    controller: 'ArticleCtrl'
