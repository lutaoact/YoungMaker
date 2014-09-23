'use strict'

angular.module('budweiserApp').controller 'TeacherQuestionLibraryCtrl', (
  $scope
  $state
  $modal
  Courses
  Categories
  Restangular
) ->

  course = _.find Courses, _id:$state.params.courseId
  category = _.find Categories, _id:course.categoryId

  angular.extend $scope,
    course: course
    category: category
    questions: null
    keyPoints: null
    selectedKeyPoints: []
    keyword: ''

    getCorrectInfo: (question) ->
      info = _.reduce question.content.body, (result, option, index) ->
        if option.correct==true
          result += String.fromCharCode(65+index)
        result
      , ''
      if info == '' then '?' else info

    getSelectedNum: ->
      _.reduce $scope.questions, (sum, q) ->
        sum + (if q.$selected then 1 else 0)
      , 0

    toggleSelectAll: (selected) ->
      angular.forEach $scope.questions, (q) -> q.$selected = selected

    toggleKeyPoint: (keyPoint) ->
      keyPoint.$selected = !keyPoint.$selected
      $scope.selectedKeyPoints = _.filter $scope.keyPoints, (k) -> k.$selected
      $scope.searchQuestions()

    addNewQuestion: ->
      $modal.open
        templateUrl: 'app/teacher/teacherLecture/newQuestion.html'
        controller: 'NewQuestionCtrl'
        resolve:
          keyPoints: -> $scope.keyPoints
          categoryId: -> course.categoryId
      .result.then (question) ->
        Restangular.all('questions').post(question)
        .then (newQuestion) ->
          $scope.questions.push newQuestion

    addToLecture: ->
      $scope.updating = true
      Restangular.one('lectures', $state.params.lectureId).get()
      .then (lecture) ->
        questionType = $state.params.questionType
        questions = _.pluck lecture[questionType], '_id'
        newQuestions = _.chain($scope.questions)
         .filter((q)  -> q.$selected == true)
         .pluck('_id')
         .union(questions)
         .value()
        patch = {}
        patch[questionType] = newQuestions
        lecture.patch(patch)
      .then ->
        $scope.updating = true
        $state.go('teacher.lecture', {
          courseId: $state.params.courseId
          lectureId: $state.params.lectureId
        })

    searchQuestions: ->
      categoryId = course.categoryId
      Restangular.all('questions').getList(
        categoryId:categoryId
        keyword: $scope.keyword
        keyPointIds: JSON.stringify _.pluck($scope.selectedKeyPoints, '_id')
      ).then (questions) ->
        $scope.questions = questions
        console.debug 'found', questions

  Restangular.all('key_points').getList(categoryId:course.categoryId)
  .then (keyPoints) ->
    $scope.keyPoints = keyPoints
    $scope.searchQuestions()

