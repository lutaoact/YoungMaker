'use strict'

angular.module('budweiserApp').controller 'TeacherHomeCtrl', (
  $scope
  $state
  Classes
  Courses
  Categories
) ->

  angular.extend $scope,
    eventSouces: [
      [
        {
          title: '通信工程CAD制图'
          startTime: moment().day(0).hours(9).minutes(0)
          endTime: moment().day(0).hours(12).minutes(25)
          subtitle:'很长的班级名字2012级通信技术J1班很长的班级名字2012级通信技术J1班很长的班级名字2012级通信技术J1班'
        }
        {
          title: '通信工程CAD制图'
          startTime: moment().day(0).hours(13).minutes(30)
          endTime: moment().day(0).hours(17).minutes(0)
          subtitle:'很长的班级名字2012级通信技术J1班很长的班级名字2012级通信技术J1班很长的班级名字2012级通信技术J1班'
        }
      ]
      [
        {
          title: '很长的课程名字很长的课程名字很长的课程名字。。。。。计算机基础'
          startTime: moment().day(1).hours(9).minutes(0)
          endTime: moment().day(1).hours(12).minutes(25)
          subtitle:'2013级通信技术J1班'
        }
        {
          title: '很长的课程名字很长的课程名字很长的课程名字。。。。。计算机基础'
          startTime: moment().day(1).hours(14).minutes(15)
          endTime: moment().day(1).hours(17).minutes(0)
          subtitle:'2013级通信技术J1班'
        }
      ]
      [
        {
          title: '网络工程技术基础'
          startTime: moment().day(2).hours(9).minutes(0)
          endTime: moment().day(2).hours(12).minutes(25)
          subtitle:'2013级通信技术J1班'
        }
        {
          title: '很长的课程名字很长的课程名字很长的课程名字。。。。。计算机基础'
          startTime: moment().day(2).hours(14).minutes(15)
          endTime: moment().day(2).hours(17).minutes(0)
          subtitle:'很长的班级名字2012级通信技术J1班很长的班级名字2012级通信技术J1班很长的班级名字2012级通信技术J1班'
        }
      ]
      [
        {
          title: '网络工程技术基础'
          startTime: moment().day(3).hours(9).minutes(0)
          endTime: moment().day(3).hours(12).minutes(25)
          subtitle:'2013级通信技术J1班'
        }
        {
          title: '很长的课程名字很长的课程名字很长的课程名字。。。。。计算机基础'
          startTime: moment().day(3).hours(14).minutes(15)
          endTime: moment().day(3).hours(17).minutes(0)
          subtitle:'很长的班级名字2012级通信技术J1班很长的班级名字2012级通信技术J1班很长的班级名字2012级通信技术J1班'
        }
      ]
      [
        {
          title: '体育课'
          startTime: moment().day(4).hours(9).minutes(0)
          endTime: moment().day(4).hours(11).minutes(35)
          subtitle:'2011级通信技术J1班'
        }
        {
          title: '体育课'
          startTime: moment().day(4).hours(12).minutes(25)
          endTime: moment().day(4).hours(14).minutes(15)
          subtitle:'2011级通信技术J1班'
        }
        {
          title: '体育课'
          startTime: moment().day(4).hours(15).minutes(25)
          endTime: moment().day(4).hours(17).minutes(0)
          subtitle:'很长的班级名字2012级通信技术J1班很长的班级名字2012级通信技术J1班很长的班级名字2012级通信技术J1班'
        }
      ]
    ]

    $state: $state
    courses: Courses
    classes: Classes
    categories: Categories

    toggleLectures: (course) ->
      stateName =
        if $state.includes('teacher.course.lectures')
          'teacher.course'
        else
          'teacher.course.lectures'
      $state.go(stateName, courseId:course._id)
