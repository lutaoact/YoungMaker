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
      $scope.studentsStatus = offlineWorks.map (item)->
        if item.checked?
          id: item.userId
          className: 'fa fa-check'
        else if item.submitted?
          id: item.userId
          className: 'fa fa-paperclip'
        else
          id: item.userId
      $scope.offlineWorks = offlineWorks

  $scope.$watch 'lecture', (value)->
    if value
      getAllOfflineWorks()

  angular.extend $scope,
    offlineWorks: undefined

    selectedOfflineWork: undefined

    selectedStudent: undefined

    isImage: (ext)->
      /(png|jpeg|gif|jpg)/i .test ext

    viewStudentOfflineWork: (student)->
      $scope.selectedStudent = student
      $scope.selectedOfflineWork = _.find $scope.offlineWorks, (item)-> item.userId is student._id

    submitOfflineWork: ()->
      $scope.selectedOfflineWork.checked = true

      $scope.selectedOfflineWork.all('score').post
        score: $scope.selectedOfflineWork.score
        feedback: $scope.selectedOfflineWork.feedback
      .then (data)->
        console.log data
        angular.extend $scope.selectedOfflineWork, data

