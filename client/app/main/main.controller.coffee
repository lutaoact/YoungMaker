'use strict'

angular.module('budweiserApp').controller 'MainCtrl',
(
  $scope
  $http
  Auth
  $state
  $location
) ->

  angular.extend $scope,
    menu: [
      {
        title: '主页'
        link: 'teacher.home'
        role: 'teacher'
      }
      {
        title: '主页'
        link: 'student.courseList'
        role: 'student'
      }
      {
        title: '管理组'
        link: 'admin.classeManager'
        role: 'admin'
      }
    ]
    brands: null

    loadBrands: ()->
      @brands = _.map [1..5], (id) ->
        _id: id
        url: 'http://lorempixel.com/1280/720/abstract/?id=' + id
        title: 'Brand' + id

    features: null

    loadFeatures: ()->
      @features = _.map [1..3], (id) ->
        _id: id
        image: 'http://lorempixel.com/340/180/cats/?id=' + id
        title: 'Feature' + id
        content: """
          Lorem ipsum dolor sit amet, consectetur adipisicing elit.
          Labore facilis ipsum quibusdam officia, error vel, sed
          nesciunt totam est soluta officiis alias nemo, quia sit
          quisquam ducimus, molestias assumenda quos.
        """.substr(0,Math.floor(Math.random() * 100) + 100)

    showcases: null

    loadShowcases: ()->
      @showcases = _.map [1..6], (id)->
        _id:id
        thumbnail: 'http://lorempixel.com/340/180/nature/?id=' + id
        title: 'Showcase' + id
        desc: """
          Lorem ipsum dolor sit amet, consectetur adipisicing elit.
          Labore facilis ipsum quibusdam officia, error vel, sed
          nesciunt totam est soluta officiis alias nemo, quia sit
          quisquam ducimus, molestias assumenda quos.
        """.substr(0,Math.floor(Math.random() * 100) + 100)

    plans: null

    loadPlans: ()->
      @plans = _.map [1..3], (id)->
        _id:id
        title:'Plan' + id
        price: '¥' + id * 20
        details: [
          {
            sum: 10 * id
            item: 'Lectures'
          }
          {
            sum: 10 * id
            item: 'Gb storage'
          }
          {
            sum: 10 * id
            item: 'Co-workers'
          }

        ]
      @plans[1].main = true

    staffs: null

    loadStaffs: ()->
      @staffs = _.map [1..6], (id)->
        _id:id
        title: ['Frontend', 'Backend', 'Designer'][id % 3]
        name: 'Lorem ' + id
        avatar: 'http://lorempixel.com/128/128/people/?id=' + id
    # Nav bar
    isLoggedIn: Auth.isLoggedIn
    getCurrentUser: Auth.getCurrentUser

    logout: ->
      Auth.logout()
      $location.path '/login'

    isActive: (route) ->
      route is $state.current.name

  $scope.loadBrands() and
  $scope.loadFeatures() and
  $scope.loadShowcases() and
  $scope.loadPlans() and
  $scope.loadStaffs()
