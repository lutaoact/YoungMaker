angular.module('mauiApp')

.config ($stateProvider) ->

  $stateProvider

  .state 'courseEditor',
    url: '/course-editor/:courseId'
    templateUrl: 'app/course/course-editor/course-editor.html'
    controller: 'CourseEditorCtrl'
