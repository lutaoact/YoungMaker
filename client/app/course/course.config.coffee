angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'courseDetail',
    url: '/courses/:courseId'
    templateUrl: 'app/course/courseDetail/courseDetail.html'
    controller: 'CourseDetailCtrl'

  .state 'courseList',
    url: '/courses'
    templateUrl: 'app/course/courseList/courseList.html'
    controller: 'CourseListCtrl'

  .state 'courseEditor',
    url: '/course-editor/:courseId'
    templateUrl: 'app/course/courseEditor/courseEditor.html'
    controller: 'CourseEditorCtrl'
