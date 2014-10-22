'use strict'

angular.module('budweiserApp')

.directive 'studentOfflineWorks', ->
  restrict: 'E'
  replace: true
  controller: 'StudentOfflineWorksCtrl'
  templateUrl: 'app/teacher/teacherLecture/studentOfflineWorks.html'
  scope:
    lecture: '='
    classes: '='

.controller 'StudentOfflineWorksCtrl', (
  $scope
  $state
  $modal
  $timeout
  Restangular
  $q
) ->

  getAllOfflineWorks = ()->
    Restangular.all('offline_works').getList(lectureId: $scope.lecture._id)
    .then (offlineWorks)->
      console.log offlineWorks
      $scope.offlineWorks = offlineWorks

  $scope.$watch 'lecture', (value)->
    if value
      getAllOfflineWorks()

  angular.extend $scope,
    offlineWorks: undefined

    selectedOfflineWork: undefined

    viewStudentOfflineWork: (student)->
      $scope.selectedOfflineWork = _.find $scope.offlineWorks, (item)-> item.userId is student._id

    submitOfflineWork: ()->
      $scope.selectedOfflineWork.checked = true
      $scope.selectedOfflineWork.put()
      .then (data)->
        angular.extend $scope.selectedOfflineWork, data
