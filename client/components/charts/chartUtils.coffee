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
          type: 'area'
          zoomType: 'x'
          height: 230
        # Hide watermark
        credits:
          enabled: false

        plotOptions:
          series:
            color: '#E6505F'
            fillOpacity: 0.1
            dataLabels:
              enabled: true
              format: '{point.correctNum}/{point.total}'
        tooltip:
          useHTML: true
          headerFormat: ''
          pointFormat: '{point.name}:{point.y:.1f}%'
      series: [
      ]
      xAxis:
        title:
          text: '课时'
        labels:
          formatter: ()->
            this.value + 1
        min: -0.1
        tickInterval: 1
        minorTickLength: 0
        minorTickInterval: 1
        minorGridLineDashStyle: 'longdash'
      yAxis:
        title:
          text: '百分率(%)'
        max: 100
        min: 0
        tickInterval: 25
        gridLineDashStyle: 'longdash'
      title:
        text: '折线图'
      loading: true

    # Pie Chart template
    pieChart:
      options:
        chart:
          type: 'pie'
          height: 160
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
            # For responsive
            dataLabels:
              enabled: false
            showInLegend: true
        # Show in percentage
        tooltip:
          useHTML: true
          headerFormat: ''
          pointFormat: '{point.name}'

      series: [
        {
          type:'pie'
          name:'百分率'
          size: '100%'
          innerSize: '95%'
          data: []
        }
      ]
      title:
        verticalAlign: 'bottom'
        style:
          fontSize: '12px'
        text: ''

      loading: true

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
              format: '{point.correctNum}/{point.total}'
          bar:
            cursor: 'pointer'
            pointWidth: 30
        tooltip:
          useHTML: true
          headerFormat: ''
          pointFormat: '掌握度：{point.y:.1f}%'
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
      loading: true

  genStatsOnScope: ($scope, courseId, userId)->
    $scope.quizStats = angular.copy(chartConfigs.pieChart)
    $scope.keypointStats = angular.copy(chartConfigs.pieChart)
    $scope.homeworkStats = angular.copy(chartConfigs.pieChart)
    $scope.quizTrendChart = angular.copy chartConfigs.trendChart
    $scope.homeworkTrendChart = angular.copy chartConfigs.trendChart
    $scope.keypointBarChart = angular.copy chartConfigs.verticalBarChart

    loadQuizStats = ()->
      Restangular.one('quiz_stats','').get({courseId:courseId, userId:userId})
      .then (result)->
        result.$text = '随堂问题'
        $scope.quizStats.series[0].data = [
          {
            name: '答对' + result.summary.correctNum + '题'
            y: result.summary.percent
            color: '#E84D50'
          }
          {
            name: '答错' + ~~(result.summary.correctNum * 100 / result.summary.percent - result.summary.correctNum) + '题'
            y: 100 - result.summary.percent
            color: '#ebebeb'
          }]
        $scope.quizStats.title.text = '随堂问题正确率'
        $scope.quizStats.loading = false
        result

    loadHomeworkStats = ()->
      Restangular.one('homework_stats','').get({courseId:courseId, userId:userId})
      .then (result)->
        result.$text = '课后习题'
        $scope.homeworkStats.series[0].data = [
          {
            name: '答对' + result.summary.correctNum + '题'
            y: result.summary.percent
            color: '#5cb85c'
          }
          {
            name: '答错' + ~~(result.summary.correctNum * 100 / result.summary.percent - result.summary.correctNum) + '题'
            y: 100 - result.summary.percent
            color: '#ebebeb'
          }]
        $scope.homeworkStats.title.text = '课后习题正确率'
        $scope.homeworkStats.loading = false
        result

    loadKeypointStats = ()->
      Restangular.one('keypoint_stats','').get({courseId:courseId, userId:userId})
      .then (result)->
        result.$text = '知识点掌握程度'
        $scope.keypointStats.series[0].data = [
          {
            name: '答对' + result.summary.correctNum + '题'
            y: result.summary.percent
            color: '#F69226'
          }
          {
            name: '答错' + ~~(result.summary.correctNum * 100 / result.summary.percent - result.summary.correctNum) + '题'
            y: 100 - result.summary.percent
            color: '#ebebeb'
          }
        ]
        $scope.keypointStats.title.text = '知识点掌握程度'
        $scope.keypointStats.loading = false
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

        $scope.quizTrendChart.series = results.slice(0,1).map (stats, index)->
          data: results[3].map (lecture)->
            name: lecture.name
            y: stats[lecture._id]?.percent ? 0
            correctNum: stats[lecture._id]?.correctNum ? 0
            total: ~~(100 * stats[lecture._id]?.correctNum / stats[lecture._id]?.percent)
        $scope.quizTrendChart.loading = false

        $scope.homeworkTrendChart.series = results.slice(1,2).map (stats, index)->
          data: results[3].map (lecture)->
            name: lecture.name
            y: stats[lecture._id]?.percent ? 0
            correctNum: stats[lecture._id]?.correctNum ? 0
            total: ~~(100 * stats[lecture._id]?.correctNum / stats[lecture._id]?.percent)
        $scope.homeworkTrendChart.loading = false

        # fill the key points
        keypointsMap = _.indexBy $scope.keypoints, '_id'

        sortedStats = _.sortBy results[2].stats, (item) -> item.percent
        $scope.keypointBarChart.xAxis.categories = _.map sortedStats, (item)->
          keypointsMap[item.kpId]?.name
        $scope.keypointBarChart.series[0].data = _.map sortedStats, (item)->
          y: item.percent
          correctNum: item.correctNum ? 0
          total : ~~(100 * item.correctNum / item.percent)

        $scope.keypointBarChart.options.chart.height = $scope.keypointBarChart.series[0].data.length * 50 + 120
        $scope.keypointBarChart.title.text = '知识点掌握程度统计'
        $scope.keypointBarChart.loading = false

    loadStats()

