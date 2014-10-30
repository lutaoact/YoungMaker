'use strict'

angular.module('mauiApp').config ($stateProvider) ->
  $stateProvider.state 'forum',
    url: '/forums'
    templateUrl: 'app/forum/forum.html'
    controller: 'ForumCtrl'
    resolve:
      Courses: (Restangular)->
        Restangular.all('courses').getList().then (courses)->
          courses
        , (err)->
          # handle
          []
      CurrentUser: (Auth)->
        Auth.getCurrentUser()

      AllKeypoints: (Restangular)->
        Restangular.all('key_points').getList()
        .then (data)->
          data
        , (err)->
          # handle
          console.log err
          []

    abstract: true
    authenticate: true
