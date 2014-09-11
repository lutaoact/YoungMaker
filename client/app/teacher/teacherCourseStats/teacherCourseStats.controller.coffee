'use strict'

angular.module('budweiserApp').controller 'TeacherCourseStatsCtrl', (
  Auth
  $http
  notify
  $scope
  $state
  $upload
  Classes
  fileUtils
  Categories
  Restangular
) ->

  loadStats = ->
    if $state.params.courseId is 'new'
      $scope.course = {}
    else
      # load courses
      Restangular.one('courses',$state.params.courseId).get()
      .then (course)->
        $scope.course = course
        Restangular.all('lectures').getList(courseId:course._id)
        .then (lectures) ->
          $scope.course.$lectures = _.map($scope.course.lectureAssembly, (id) -> _.find(lectures, _id:id))

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
        plotOptions:
          pie:
            allowPointSelect: true
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

    categories: Categories
    classes: Classes
    course: undefined
    state:
      uploading: false
      uploadProgress: ''

    deleteLecture: (lecture)->
      lecture.remove(courseId:$scope.course._id)
      .then ->
        lectures = $scope.course.$lectures
        lectures.splice(lectures.indexOf(lecture), 1)

    deleteStats: (course) ->
      course.remove().then ->
        $state.go('teacher.home')

    saveStats: (course, form)->
      unless form.$valid then return
      if course._id?
        # update exists
        Restangular.copy(course).put()
        .then (newStats) ->
          course.__v = newStats.__v
      else
        # create new
        Restangular.all('courses').post(course)
        .then (newStats)-> $scope.course = newStats

    selectClasse: (classe) ->
      classes = $scope.course.classes
      $scope.course.patch(classes:
        if _.contains(classes, classe._id)
          _.without(classes, classe._id)
        else
          _.union(classes, [classe._id])
      )
      .then (newStats) ->
        $scope.course.classes = newStats.classes


    onThumbSelect: (files) ->
      $scope.state.uploading = true
      fileUtils.uploadFile
        files: files
        validation:
          max: 2*1024*1024
          accept: 'image'
        success: (key) ->
          $scope.state.uploading = false
          $scope.course.thumbnail = key
          $scope.course?.patch?(thumbnail: $scope.course.thumbnail)
        fail: (error)->
          $scope.state.uploading = false
          notify(error)
        progress: (speed,percentage, evt)->
          $scope.state.uploadProgress = parseInt(100.0 * evt.loaded / evt.total) + '%'

    chartConfigs: chartConfigs

  $scope.$on 'ngrr-reordered', ->
    $scope.course.patch lectureAssembly:_.pluck($scope.course.$lectures, '_id')

  loadStats()
