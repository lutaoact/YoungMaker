'use strict'

angular.module('budweiserApp').controller 'StudentCourseStatsCtrl', (
  Auth
  $http
  notify
  $scope
  $state
  $upload
  qiniuUtils
  Restangular
  $q
  $rootScope
) ->

  $rootScope.additionalMenu = [
    {
      title: '课程主页<i class="fa fa-home"></i>'
      link: "student.courseDetail({courseId:'#{$state.params.courseId}'})"
      role: 'student'
    }
    {
      title: '讨论<i class="fa fa-comments-o"></i>'
      link: "forum.course({courseId:'#{$state.params.courseId}'})"
      role: 'student'
    }
    {
      title: '统计<i class="fa fa-bar-chart-o"></i>'
      link: "student.courseStats({courseId:'#{$state.params.courseId}'})"
      role: 'student'
    }
  ]

  $scope.$on '$destroy', ()->
    $rootScope.additionalMenu = []

  loadQuizStats = ()->
    Restangular.one('quiz_stats','my_view').get(courseId:$state.params.courseId).then (result)->
      $scope.quizStats = angular.copy(chartConfigs.pieChart)
      $scope.quizStats.series = [
        {
          type:'pie'
          name:'题目个数'
          size: '80%'
          innerSize: '60%'
          dataLabels:
            enabled: true
            formatter: ()->
              this.percentage + '%'
          data: [
            ['答对',result.summary.correctNum ]
            {
              name:'答错'
              y:(result.summary.questionsLength - result.summary.correctNum)
            }
          ]
        }
      ]
      $scope.quizStats.title =
        text: '随堂问题'

  loadHomeworkStats = ()->
    Restangular.one('homework_stats','student').get(courseId:$state.params.courseId).then (result)->
      console.log result
      $scope.homeworkStats = angular.copy(chartConfigs.pieChart)
      $scope.homeworkStats.series = [
        {
          type:'pie'
          name:'课后习题'
          size: '80%'
          innerSize: '60%'
          dataLabels:
            enabled: true
            formatter: ()->
              this.percentage + '%'
          data: [
            ['答对',result.summary / 100 ]
            {
              name:'答错'
              y: (100 - result.summary) / 100
            }
          ]
        }
      ]
      $scope.homeworkStats.title =
        text: '课后习题'

  loadKeypointStats = ()->
    Restangular.one('keypoint_stats','my_view').get(courseId:$state.params.courseId).then (result)->


  loadStats = ->
    $q.all([loadQuizStats(), loadHomeworkStats(), loadKeypointStats()]).then (results)->
      console.log results

  chartConfigs =
    trendChart:
      options:
        chart:
          type: 'line'
          zoomType: 'x'
      series: [
        {
          name:'观看次数'
          data: [0, 0, 0, 0, 0, 0, 0]
        }
      ]
      xAxis:
        type: 'category'
        title:
          text: '日期'

      yAxis:
        title:
          text: '次数'
      loading: true
      title:
        text: ''

    pieChart:
      options:
        credits:
          enabled: false
        plotOptions:
          pie:
            cursor: 'pointer'
            dataLabels:
              enabled: false
            showInLegend: true
      series: [
        {
          type:'pie'
          name:'观看情况'
          data: [
            ['未观看',12]
            {
              name:'正在看'
              y:30
              sliced: true
              selected: true
            }
            ['已观看',25]
          ]
        }
      ]
      title:
        text: '观看人数'

    questionChart:
      options:
        credits:
          enabled: false
        chart:
          type: 'column'
        exporting:
          enabled: false
        xAxis:
          type: 'category'
        legend:
          enabled: false
        plotOptions:
          series:
            borderWidth: 0
            dataLabels:
              enabled: true
          column:
            cursor: 'pointer'
        drilldown:
          series: _.map [1..8], (num)->
            id: 'drilldown' + num
            name: 'Question' + num
            data: _.map [1..4], (option)->
              [ 'ABCD'[option-1], Math.floor((num * 2 % 3 + 10) / 4) + option]
      series: [
        {
          name:'回答数'
          colorByPoint: true,
          data: _.map [1..8], (id)->
            name: 'Question' + id
            y: id * 2 % 3 + 10
            drilldown: 'drilldown' + id
        }
      ]
      title:
        text: '问答统计'
      subtitle:
        text: 'Click the columns to view answer detail.'

    scatterChart:
      options:
        chart:
          type: 'scatter'
          zoomType: 'xy'
      title:
        text: '观看分布'
      xAxis:
        title:
          enabled: true
          text: '日期'
        startOnTick: true
        endOnTick: true
        showLastLabel: true
      yAxis:
        title:
          text: '时间'
      series:[
        {
          name: '观看'
          color: 'rgba(223, 83, 83, .5)'
          data: _.map [1..1000], (id)->
            [Math.random() * 7, Math.random() * 2 + id % 2 * 12 + 7 ]
        }
      ]

  angular.extend $scope,

    chartConfigs: chartConfigs

    quizStats: undefined

  loadStats()
