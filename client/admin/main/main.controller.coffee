'use strict'

angular.module 'mauidmin'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/'
    templateUrl: 'admin/main/main.html'
    controller: 'MainCtrl'
    authenticate: true

.controller 'MainCtrl', ($scope, Restangular, notify) ->

  Restangular.all('courses').getList()
  .then (courses)->
    $scope.courses = courses

  Restangular.all('categories').getList()
  .then (categories)->
    $scope.categories = categories

  Restangular.all('articles').getList()
  .then (articles)->
    $scope.articles = articles

  Restangular.all('groups').getList()
  .then (groups)->
    $scope.groups = groups

  angular.extend $scope,
    courses: undefined
    gradeSubjects: undefined
    newGradeSubject: {}

    onImageUploaded: ($data, entity, field)->
      entity[field] = $data

    newCategory: {}

    createCategory: ()->
      Restangular.all('categories').post $scope.newCategory
      .then (data)->
        $scope.categories?.push data
        $scope.newCategory = {}

    saveCategory: (category)->
      if category and category.logo and category.name
        category.put()
        .then (data)->
          notify
            message: data

    removeEntity: (entity, entities)->
      entity.remove()
      .then (data)->
        entities?.splice entities.indexOf(entity), 1
        notify
          message: data

    toggleFeatured: (entity)->
      entity.patch
        featured: if entity.featured then null else new Date()
      .then (data)->
        angular.extend entity, data






