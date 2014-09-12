'use strict'

angular.module('budweiserApp').controller 'StudentCourseListCtrl'
, (
  User
  Auth
  $http
  $scope
  notify
  $upload
  Courses
) ->

  angular.extend $scope,

    courses: undefined

    loadCourses: ()->
      $scope.courses = Courses

    startCourse: (event)->
      console.log event

    eventSouces: [
      [
        {
          title: '通信工程CAD制图'
          color: '#999900'
          startTime: moment().day(0).hours(9).minutes(0)
          endTime: moment().day(0).hours(12).minutes(25)
          weeks: 16
          currentWeek: 2
        }
        {
          title: '通信工程CAD制图'
          color: '#999900'
          startTime: moment().day(0).hours(13).minutes(30)
          endTime: moment().day(0).hours(17).minutes(0)
          weeks: 16
          currentWeek: 2
        }
      ]
      [
        {
          title: '很长的课程名字很长的课程名字很长的课程名字。。。。。计算机基础'
          color: '#990000'
          startTime: moment().day(1).hours(9).minutes(0)
          endTime: moment().day(1).hours(12).minutes(25)
          weeks: 16
          currentWeek: 2
        }
        {
          title: '很长的课程名字很长的课程名字很长的课程名字。。。。。计算机基础'
          color: '#990000'
          startTime: moment().day(1).hours(14).minutes(15)
          endTime: moment().day(1).hours(17).minutes(0)
          weeks: 16
          currentWeek: 2
        }
      ]
      [
        {
          title: '网络工程技术基础'
          color: '#990099'
          startTime: moment().day(2).hours(9).minutes(0)
          endTime: moment().day(2).hours(12).minutes(25)
          weeks: 16
          currentWeek: 2
        }
        {
          title: '很长的课程名字很长的课程名字很长的课程名字。。。。。计算机基础'
          color: '#990000'
          startTime: moment().day(2).hours(14).minutes(15)
          endTime: moment().day(2).hours(17).minutes(0)
          weeks: 16
          currentWeek: 2
        }
      ]
      [
        {
          title: '网络工程技术基础'
          color: '#990099'
          startTime: moment().day(3).hours(9).minutes(0)
          endTime: moment().day(3).hours(12).minutes(25)
          weeks: 16
          currentWeek: 2
        }
        {
          title: '很长的课程名字很长的课程名字很长的课程名字。。。。。计算机基础'
          color: '#990000'
          startTime: moment().day(3).hours(14).minutes(15)
          endTime: moment().day(3).hours(17).minutes(0)
          weeks: 16
          currentWeek: 2
        }
      ]
      [
        {
          title: '体育课'
          color: '#009900'
          startTime: moment().day(4).hours(9).minutes(0)
          endTime: moment().day(4).hours(11).minutes(35)
          weeks: 32
          currentWeek: 2
        }
        {
          title: '体育课'
          color: '#009900'
          startTime: moment().day(4).hours(12).minutes(25)
          endTime: moment().day(4).hours(14).minutes(15)
          weeks: 32
          currentWeek: 2
        }
        {
          title: '体育课'
          color: '#009900'
          startTime: moment().day(4).hours(15).minutes(25)
          endTime: moment().day(4).hours(17).minutes(0)
          weeks: 32
          currentWeek: 2
        }
      ]
    ]

  $scope.loadCourses()
