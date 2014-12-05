angular.module 'mauiApp'
.config ()->
  Highcharts.setOptions
    lang:
      downloadJPEG: '另存为jpg'
      downloadPDF: '另存为pdf'
      downloadPNG: '另存为png'
      downloadSVG: '另存为svg'
      loading: '加载中'
      printChart: '打印图表'
      resetZoom: '复原'



