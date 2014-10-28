'use strict'

angular.module('budweiserApp').directive 'teacherQuestionItemStats', ->
  templateUrl: 'app/teacher/teacherQuestionLibrary/teacherQuestionItemStats.html'
  restrict: 'E'
  replace: true
  scope:
    question: '='

  controller: ($scope, chartUtils, Restangular, $state, $filter)->

    genTooltip = (students)->
      if students?.length
        studentListHtml = '<div class="students">' + (students.map (student)->
          "<label class='pull-left'><div class='avatar-xs pull-left' style='background-image: url(\"#{student.avatar}\")'></div><a href='t/courses/#{$state.params.courseId}/stats/students/#{student._id}'>#{student.name}</a></label>"
        ).join('') + '</div>'

        tooltipHtml = "<div class='students-tooltip'>#{studentListHtml}</div>"
      else
        '无'


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
          min: 0
          allowDecimals: false
        series: [
          {
            name: '人数'
            data: [
                y: 67
                color: '#5ABDA6'
              ,
                color: '#E84D50'
                y: 10
              ,
                color: '#F6B955'
                y: 3
            ]
          }
        ]
        title:
          text: ''
        loading: true

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
          tooltip:
            useHTML: true
            headerFormat: ''
            pointFormat: '{point.tooltipHtml}'
            footerFormat: ''

        xAxis:
          type: 'category'
          categories: []

        yAxis:
          title:
            text: '人数'
          min: 0
          allowDecimals: false
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

        loading: true

    $scope.$watch 'question', (value)->
      if value
        Restangular.one('lecture_stats','').get
          courseId: $state.params.courseId
          lectureId: $state.params.lectureId
          questionId: value._id
        .then (data)->
          console.log data
          # right answers
          $scope.responseRateConfig.series[0].data[0].y = data.right.length
          $scope.responseRateConfig.series[0].data[0].tooltipHtml = genTooltip(data.right)

          # wrong answers
          $scope.responseRateConfig.series[0].data[1].y = data.wrong.length
          $scope.responseRateConfig.series[0].data[1].tooltipHtml = genTooltip(data.wrong)

          # un answered
          $scope.responseRateConfig.series[0].data[2].y = data.unanswered.length
          $scope.responseRateConfig.series[0].data[2].tooltipHtml = genTooltip(data.unanswered)

          $scope.responseRateConfig.loading = false

          # right answers
          data.answerStat.forEach (item, index)->
            $scope.optionsStatsConfig.series[0].data[index] ?= {}
            $scope.optionsStatsConfig.series[0].data[index].y = data.answerStat[index].length
            $scope.optionsStatsConfig.xAxis.categories.push $filter('indexToABC')(index)
            $scope.optionsStatsConfig.series[0].data[index].tooltipHtml = genTooltip(data.answerStat[index])

          $scope.optionsStatsConfig.loading = false








