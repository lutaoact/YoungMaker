angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'courseDetail',
    url: '/courses/:courseId'
    templateUrl: 'app/course/course-detail/course-detail.html'
    controller: 'CourseDetailCtrl'
    resolve:
      CurrentUser: (Auth)->
        Auth.getCurrentUser()
