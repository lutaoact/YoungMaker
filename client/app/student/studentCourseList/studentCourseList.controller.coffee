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
  Restangular
) ->

  generateTimetable = (schedules, day)->
    eventSouces = [1..5].map -> []
    today = day or moment()
    weekStart = today.clone().isoWeekday(1)
    weekEnd = today.clone().isoWeekday(5)
    schedules.forEach (schedule)->
      if moment(schedule.start).isAfter weekEnd or moment(schedule.until).isBefore weekStart
        # not shown
        console.log 'out of date'
      else
        isoWeekday =  moment(schedule.start).isoWeekday() # 1,2...7
        event = {}
        event.title = schedules.course.name
        event.$course = schedules.course
        event.startTime = moment(schedule.start).weeks(today.weeks())
        event.currentWeek = today.weeks() - moment(schedule.start).weeks()
        event.weeks = moment(schedule.until).weeks() - moment(schedule.start).weeks()
        event.endTime = moment(schedule.end).weeks(today.weeks())
        eventSouces[isoWeekday - 1].push event
        # Test
        $scope.eventSouces[isoWeekday - 1].push event
    eventSouces

  angular.extend $scope,

    courses: undefined

    loadCourses: ()->
      $scope.courses = Courses

    startCourse: (event)->
      console.log event

    loadTimetable: ()->
      Restangular.all('schedules').getList()
      .then (schedules)->
        # Compose this week
        generateTimetable(schedules)

    nextWeek: ()->


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
  $scope.loadTimetable()
