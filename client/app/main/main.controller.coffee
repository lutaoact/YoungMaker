'use strict'

angular.module('mauiApp').controller 'MainCtrl', (
  $scope
  Restangular
) ->

  angular.extend $scope,
    courses: [
      {
        title: 'EV3智能机器人RSTORM'
        image: '/api/assets/images/0/Cr7cgZp88w/20140324094718680.jpg'
        ingredients: [
          {
            name: '路由器'
            image: '/api/assets/images/0/Cr7cgZp88w/20140324094718680.jpg'
            quantity: 1
          }
          {
            name: '照相机'
            image: '/api/assets/images/0/Cr7cgZp88w/20140324094718680.jpg'
            quantity: 1
          }
          {
            name: '网线'
            image: '/api/assets/images/0/Cr7cgZp88w/20140324094718680.jpg'
            quantity: 2
          }
          {
            name: '遥控器'
            image: '/api/assets/images/0/Cr7cgZp88w/20140324094718680.jpg'
            quantity: 1
          }
          {
            name: '遥控器'
            image: '/api/assets/images/0/Cr7cgZp88w/20140324094718680.jpg'
            quantity: 1
          }
          {
            name: '遥控器'
            image: '/api/assets/images/0/Cr7cgZp88w/20140324094718680.jpg'
            quantity: 1
          }
        ]
        postBy:
          name: 'STEM联盟'
          avatar: ''
        likes: 10
        views: 100
        mades: 4
      }
      {
        title: '香蕉触摸板'
        image: '/api/assets/images/0/Cr7cgZp88w/20140324094718680.jpg'
        ingredients: [
          {
            name: '路由器'
            image: '/api/assets/images/0/Cr7cgZp88w/20140324094718680.jpg'
            quantity: 1
          }
          {
            name: '照相机'
            image: '/api/assets/images/0/Cr7cgZp88w/20140324094718680.jpg'
            quantity: 1
          }
          {
            name: '网线'
            image: '/api/assets/images/0/Cr7cgZp88w/20140324094718680.jpg'
            quantity: 2
          }
          {
            name: '遥控器'
            image: '/api/assets/images/0/Cr7cgZp88w/20140324094718680.jpg'
            quantity: 1
          }
          {
            name: '遥控器'
            image: '/api/assets/images/0/Cr7cgZp88w/20140324094718680.jpg'
            quantity: 1
          }
          {
            name: '遥控器'
            image: '/api/assets/images/0/Cr7cgZp88w/20140324094718680.jpg'
            quantity: 1
          }
        ]
        postBy:
          name: 'STEM联盟'
          avatar: ''
        likes: 10
        views: 100
        mades: 4
      }
    ]

  Restangular.all('articles').getList()
  .then (data)->
    $scope.articles = data


