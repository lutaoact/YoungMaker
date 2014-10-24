'use strict'

angular.module('budweiserApp')

.directive 'studentLectureAnswers', ->
  restrict: 'EA'
  replace: true
  controller: 'StudentLectureAnswersCtrl'
  templateUrl: 'app/student/studentLectureDetail/studentLectureAnswers.html'
  scope:
    lecture: '='
    course: '='

.controller 'StudentLectureAnswersCtrl', (
  $scope
  Restangular
) ->

  angular.extend $scope,
    displayQuestions: []
    questionsType: 'quizzes'
    viewState:
      pageSize: 10
      currentPage:
        quizzes: 1
        homeworks: 1

    setQuestionType: (type) ->
      $scope.offlineWorksShown = false
      $scope.questionsType = type
      $scope.displayQuestions?.$active = false
      $scope.displayQuestions = $scope.lecture?[$scope.questionsType]
      $scope.displayQuestions?.$active = true

    offlineWorksShown: false

    showOfflineWorks: ()->
      $scope.displayQuestions?.$active = false
      $scope.displayQuestions = undefined
      $scope.offlineWorksShown = true

    submitAnswer: ->
      if $scope.displayQuestions is $scope.lecture.homeworks
        result = _.map $scope.displayQuestions, (question) ->
          questionId: question._id
          answer: _.reduce question.choices, (answer, choice, index) ->
            answer.push(index) if choice.$selected
            answer
          , []
        homeworkAnswer =
          subitted: true
          result: result
        Restangular.all('homework_answers').post(homeworkAnswer, lectureId:$scope.lecture._id)
        .then ()->
          # check null
          homeworks = $scope.lecture?.homeworks
          homeworks.$submitted = true
          for question in homeworks
            answer = _.find(homeworkAnswer.result, questionId:question._id)?.answer

            question.$correct = question.choices.every (choice, index)->
              if choice.correct
                answer?.some (item)-> item is index
              else
                answer?.every (item)-> item isnt index

            for choice, index in question.choices
              choice.$selected = answer?.indexOf(index) >= 0
          $scope.displayQuestions.$submitted = true

    onFilesUploaded: (data, meta)->
      meta.forEach (fileMeta)->
        $scope.offlineWork.files.some (file)->
          # should judge on md5
          if file.name is fileMeta.name and !file.url
            file.url = fileMeta.url
            file.$progress = undefined
            true
          else
            false
      console.log meta

    isImage: (ext)->
      /(png|jpeg|gif|jpg)/i .test ext

    removeFile: (file)->
      $scope.offlineWork.files.splice($scope.offlineWork.files.indexOf(file), 1)

    onError: (err)->
      console.log err

    onFilesUploadStart: ($files)->
      $scope.offlineWork.files ?= []
      $files.forEach (file)->
        $scope.offlineWork.files.push
          name: file.name
          size: file.size

    onFilesUploading: ($speed, $percentage, $event)->
      $scope.offlineWork.files.some (file)->
        if file.name is $event.$fileName
          file.$progress = 100 * $event.loaded // $event.total
          true
        else
          false

    offlineWork: undefined

    submitOfflineWork: (offlineWork)->
      offlineWork.submitted = true
      offlineWork.submittedTime = new Date()
      if offlineWork._id
        offlineWork.put()
        .then (data)->
          angular.extend offlineWork, data
      else
        Restangular.all('offline_works').post offlineWork, lectureId: $scope.lecture._id
        .then (data)->
          angular.extend offlineWork, data

  loadOfflineWork = ()->
    Restangular.all('offline_works').getList(lectureId: $scope.lecture._id)
    .then (data)->
      if data?.length
        $scope.offlineWork = data[0]
      else
        $scope.offlineWork =
          teacherId: $scope.course.owners[0]._id
          lectureId: $scope.lecture._id
      console.log $scope.offlineWork

  $scope.$watch 'lecture', ->
    if !$scope.lecture then return
    Restangular.all('key_points').getList()
    .then (keyPoints) ->
      $scope.keyPoints = keyPoints
    Restangular.all('homework_answers').getList(lectureId:$scope.lecture._id)
    .then (answers)->
      for question in $scope.lecture?.homeworks
          question.$notAnswered = false
      if answers.length > 0
        # TODO: api only return the object
        # check null
        homeworkAnswer = answers[answers.length-1]
        homeworks = $scope.lecture?.homeworks
        homeworks.$submitted = true
        for question in homeworks
          answer = _.find(homeworkAnswer.result, questionId:question._id)?.answer

          question.$correct = question.choices.every (choice, index)->
            if choice.correct
              answer?.some (item)-> item is index
            else
              answer?.every (item)-> item isnt index

          for choice, index in question.choices
            choice.$selected = answer?.indexOf(index) >= 0

    Restangular.all('quiz_answers').getList(lectureId:$scope.lecture._id)
    .then (answers)->
      if answers?.length
        # has answered, should show
        quizzes = $scope.lecture?.quizzes
        quizzes.$submitted = true
        quizzes.forEach (quiz)->
          answer = _.find(answers, questionId:quiz._id)?.result
          if answer
            quiz.$notAnswered = false
            quiz.$correct = quiz.choices.every (choice, index)->
              if choice.correct
                answer?.some (item)-> item is index
              else
                answer?.every (item)-> item isnt index

            for choice, index in quiz.choices
              choice.$selected = answer?.indexOf(index) >= 0
          else
            quiz.$notAnswered = true
        $scope.setQuestionType('quizzes')
      else
        $scope.setQuestionType('homeworks')

    loadOfflineWork()

  $scope.$on 'quiz.answered', (event, question, answer)->
    $scope.lecture.quizzes.$submitted = $scope.lecture.quizzes.some (quiz)->
      quiz._id is question._id
    if $scope.lecture.quizzes.$submitted
      $scope.lecture.quizzes.forEach (quiz)->
        if quiz._id is question._id
          quiz.$notAnswered = false
          options = answer.result
          quiz.$correct = quiz.choices.every (choice, index)->
            if choice.correct
              options?.some (item)-> item is index
            else
              options?.every (item)-> item isnt index

          for choice, index in quiz.choices
            choice.$selected = options?.indexOf(index) >= 0
