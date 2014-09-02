'use strict'

angular.module('budweiserApp').config ($stateProvider) ->
  $stateProvider.state 'forum',
    url: '/forums'
    templateUrl: 'app/forum/forum.html'
    controller: 'ForumCtrl'
    resolve:
      Courses: (Restangular)->
        Restangular.all('courses').getList().then (courses)->
          return courses
        , (err)->
          # handle
          return []
      CurrentUser: (Auth)->
        Auth.getCurrentUser()

    abstract: true
    authenticate: true
