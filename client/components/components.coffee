'use strict'

angular.module 'maui.components', [
  'cgNotify'
  'ngStorage'
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'restangular'
  'textAngular'
  'ui.router'
  'ui.bootstrap'
  'angularFileUpload'
]

.constant 'configs',
  baseUrl: ''
  fpUrl: 'http://54.223.144.96:9090/'
  cdn: 'http://public-cloud3edu-com.qiniudn.com/cdn'
  imageSizeLimitation: 3 * 1024 * 1024
  fileSizeLimitation: 30 * 1024 * 1024
  videoSizeLimitation: 30 * 1024 * 1024
  proVideoSizeLimitation: 1024 * 1024 * 1024
