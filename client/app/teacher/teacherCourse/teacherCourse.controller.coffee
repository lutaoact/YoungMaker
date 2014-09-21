'use strict'

angular.module('budweiserApp').controller 'TeacherCourseCtrl', (
  $scope
  $state
  Classes
  Courses
  $rootScope
  Categories
) ->

  $rootScope.additionalMenu = [
    {
      title: '主页'
      link: 'teacher.home'
      role: 'teacher'
    }
    {
      title: '课程主页<i class="fa fa-home"></i>'
      link: "teacher.course({courseId:'#{$state.params.courseId}'})"
      role: 'teacher'
    }
    {
      title: '统计<i class="fa fa-bar-chart-o"></i>'
      link: "teacher.courseStats({courseId:'#{$state.params.courseId}'})"
      role: 'teacher'
    }
  ]

  $scope.$on '$destroy', ()->
    $rootScope.additionalMenu = []
    $rootScope.navInSub = false

  $rootScope.navInSub = true

  angular.extend $scope,
    course: _.find Courses, _id:$state.params.courseId
    classes: Classes
    categories: Categories

    deleteCallback: (course) ->
      Courses.splice(Courses.indexOf(course), 1)
      $state.go('teacher.home')

