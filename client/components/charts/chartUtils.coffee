angular.module 'budweiserApp'
.factory 'chartUtils', (Restangular,$q)->
  chartConfigs =
    # trend for quiz and homework
    trendChart:
      options:
        # hide legend
        legend:
          enabled: false
        chart:
          type: 'spline'
          zoomType: 'x'
          height: 230
        # Hide watermark
        credits:
          enabled: false
        tooltip:
          valueSuffix: '%'
      series: [
      ]
      xAxis:
        title:
          text: '课时'
      yAxis:
        title:
          text: '百分率(%)'
        plotLines: [{
          value: 0,
          width: 1,
          color: '#808080'
        }]
        max: 100
        min: 0
        tickInterval: 25
      title:
        text: null

    # Pie Chart template
    pieChart:
      options:
        chart:
          type: 'pie'
          height: 100
        # hide legend
        legend:
          enabled: false
        # hide exporting
        exporting:
          enabled: false
        # Hide watermark
        credits:
          enabled: false
        plotOptions:
          pie:
            cursor: 'pointer'
            # For responsive
            dataLabels:
              enabled: false
            showInLegend: true
        # Show in percentage
        tooltip:
          pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
      series: [
        {
          type:'pie'
          name:'百分率'
          size: '100%'
          innerSize: '95%'
          data: []
        }
      ]

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
        text: null
      subtitle:
        text: 'Click the columns to view answer detail.'

    scatterChart:
      options:
        chart:
          type: 'scatter'
          zoomType: 'xy'
      title:
        text: null
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

    verticalBarChart:
      options:
        credits:
          enabled: false
        chart:
          type: 'bar'
        legend:
          enabled: false
        plotOptions:
          series:
            borderWidth: 0
            dataLabels:
              enabled: true
          bar:
            cursor: 'pointer'
      xAxis:
        type: 'category'

      yAxis:
        title:
          text: '百分率(%)'
        max: 100
        min: 0
        tickInterval: 25
      series: [
        {
          name:'掌握度'
        }
      ]
      title:
        text: ''

  genStatsOnScope: ($scope, courseId, studentId)->
    loadQuizStats = ()->
      Restangular.one('quiz_stats','').get({courseId:courseId, studentId:studentId})
      .then (result)->
        result.$text = '随堂问题'
        $scope.quizStats = angular.copy(chartConfigs.pieChart)
        $scope.quizStats.series[0].data = [
          {
            name:'正确'
            y: result.summary.percent
            color: '#5abda6'
          }
          {
            name:'错误'
            y: 100 - result.summary.percent
            color: '#ebebeb'
          }]
        result

    loadHomeworkStats = ()->
      Restangular.one('homework_stats','').get({courseId:courseId, studentId:studentId})
      .then (result)->
        result.$text = '课后习题'
        $scope.homeworkStats = angular.copy(chartConfigs.pieChart)
        $scope.homeworkStats.series[0].data = [
          {
            name:'正确'
            y: result.summary.percent
            color: '#5abda6'
          }
          {
            name:'错误'
            y: 100 - result.summary.percent
            color: '#ebebeb'
          }]
        result

    loadKeypointStats = ()->
      Restangular.one('keypoint_stats','').get({courseId:courseId, studentId:studentId})
      .then (result)->
        result.$text = '知识点掌握程度'
        $scope.keypointStats = angular.copy chartConfigs.pieChart
        $scope.keypointStats.series[0].data = [
          {
            name:'掌握'
            y: result.summary.percent
            color: '#5abda6'
          }
          {
            name:'未掌握'
            y: 100 - result.summary.percent
            color: '#ebebeb'
          }
        ]

        result
      , (err)->
        console.log err

    loadKeypoints = ()->
      Restangular.all('key_points').getList(courseId: courseId)
      .then (result)->
        $scope.keypoints = result

    loadLectures = ()->
      Restangular.all('lectures').getList(courseId:courseId)

    loadStats = ->
      $q.all([loadQuizStats(), loadHomeworkStats(), loadKeypointStats(), loadLectures(), loadKeypoints()])
      .then (results)->
        # fill the trend chart

        $scope.quizTrendChart = angular.copy chartConfigs.trendChart
        $scope.quizTrendChart.xAxis.categories = _.pluck results[3], 'name'
        $scope.quizTrendChart.series = results.slice(0,1).map (stats, index)->
          name: stats.$text
          data: results[3].map (lecture)->
            stats[lecture._id]?.percent ? 0

        $scope.homeworkTrendChart = angular.copy chartConfigs.trendChart
        $scope.homeworkTrendChart.xAxis.categories = _.pluck results[3], 'name'
        $scope.homeworkTrendChart.series = results.slice(1,2).map (stats, index)->
          name: stats.$text
          data: results[3].map (lecture)->
            stats[lecture._id]?.percent ? 0

        # fill the key points
        keypointsMap = _.indexBy $scope.keypoints, '_id'

        $scope.keypointBarChart = angular.copy chartConfigs.verticalBarChart
        $scope.keypointBarChart.xAxis.categories = _.map results[2].stats, (item, index)->
          keypointsMap[index]?.name
        $scope.keypointBarChart.series[0].data = _.pluck results[2].stats, 'percent'
        $scope.keypointBarChart.title =
          text: '知识点掌握程度统计'

    loadStats()

