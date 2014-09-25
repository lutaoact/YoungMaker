'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'teacher.lecture',
    url: '/courses/:courseId/lectures/:lectureId'
    templateUrl: 'app/teacher/teacherLecture/teacherLecture.html'
    controller: 'TeacherLectureCtrl'
    authenticate: true

  $stateProvider.state 'teacher.lecture.questionLibrary',
    url: '/question-library/:questionType'
    template: """
      <question-library category-id="course.categoryId"
                        key-points="course.$keyPoints"
                        lecture="lecture">
      </question-library>
    """
    authenticate: true
