'use strict'

angular.module('budweiserApp').directive 'teacherQuestionItemStats', ->
  templateUrl: 'app/teacher/teacherQuestionLibrary/teacherQuestionItemStats.html'
  restrict: 'E'
  replace: true
  scope:
    question: '='

  controller: ($scope, chartUtils, Restangular, $state)->
    students = [1..20].map (i)->
      _id: '5438f983f26f910320e27f3b'
      name: '学生啊'
      avatar: 'http://lorempixel.com/100/100/?r=' + i

    studentListHtml = '<div class="students">' + (students.map (student)->
      "<label class='pull-left'><div class='avatar-xs pull-left' style='background-image: url(\"#{student.avatar}\")'></div><a href='t/courses/#{$state.params.courseId}/stats/students/#{student._id}'>#{student.name}</a></label>"
    ).join('') + '</div>'

    tooltipHtml = "<div class='students-tooltip'>#{studentListHtml}</div>"

    angular.extend $scope,
      stats: undefined

      responseRateConfig:
        options:
          credits:
            enabled: false
          exporting:
            enabled: false
          chart:
            type: 'bar'
            height: 200
          legend:
            enabled: false
          plotOptions:
            series:
              borderWidth: 0
              dataLabels:
                enabled: true
                formatter: ()->
                  console.log this
            bar:
              cursor: 'pointer'
              pointWidth: 30
          tooltip:
            useHTML: true
            headerFormat: ''
            pointFormat: '{point.tooltipHtml}'
            footerFormat: ''
        xAxis:
          type: 'category'
          categories: ['答对','答错','未提交']


        yAxis:
          title:
            text: '人数'
          max: 100
          min: 0
          tickInterval: 25
        series: [
          {
            name: '人数'
            data: [
                y: 67
                color: '#5ABDA6'
                tooltipHtml: tooltipHtml
              ,
                color: '#E84D50'
                y: 10
                tooltipHtml: tooltipHtml
              ,
                color: '#F6B955'
                y: 3
                tooltipHtml: tooltipHtml
            ]
          }
        ]
        title:
          text: ''

      optionsStatsConfig:
        options:
          credits:
            enabled: false
          exporting:
            enabled: false
          chart:
            type: 'bar'
            height: 200
          legend:
            enabled: false
          plotOptions:
            series:
              borderWidth: 0
              dataLabels:
                enabled: true
            bar:
              cursor: 'pointer'
              pointWidth: 20
        xAxis:
          type: 'category'
          categories: ['A','B','C', 'D']

        yAxis:
          title:
            text: '人数'
          max: 100
          min: 0
          tickInterval: 25
        series: [
          {
            name: '人数'
            data: [
                y: 50
              ,
                y: 10
              ,
                y: 5
              ,
                y: 3
            ]
          }
        ]
        title:
          text: ''

    $scope.$watch 'question', (value)->
      if value
        Restangular.one('lecture_stats','').get
          courseId: $state.params.courseId
          lectureId: $state.params.lectureId
          questionId: value._id
        .then (data)->
          console.log data

