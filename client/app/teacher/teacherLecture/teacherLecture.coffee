'use strict'

angular.module('mauiApp').config ($stateProvider) ->
  $stateProvider.state 'teacher.lecture',
    url: '/courses/:courseId/lectures/:lectureId'
    templateUrl: 'app/teacher/teacherLecture/teacherLecture.html'
    controller: 'TeacherLectureCtrl'
    authenticate: true
    resolve:
      KeyPoints: (Restangular) ->
        Restangular.all('key_points').getList().then (keyPoints) ->
          keyPoints
        , -> []

  $stateProvider.state 'teacher.lecture.questionLibrary',
    url: '/question-library/:questionType'
    template: """
      <question-library category-id="course.categoryId"
                        key-points="keyPoints"
                        lecture="lecture">
      </question-library>
    """
    authenticate: true
