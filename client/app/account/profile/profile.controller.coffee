'use strict'

angular.module('budweiserApp').controller 'ProfileCtrl',
(
  Auth
  $scope
  notify
  $modal
  Restangular
) ->
  angular.extend $scope,

    me: null

    oldMe: null

    getMyProfile: ()->
      Restangular.one('users','me').get()
      .then (user)->
        $scope.me = user
        $scope.oldMe = Restangular.copy(user)

    patchMe: (field)->
      if not @me
        #post
        notify
          message:'网络错误'
          template:'components/alert/failure.html'
      else
        #put
        patch = {}
        patch[field] = @me[field]
        if patch[field] is @oldMe[field]
          # not changed
          return
        @me.patch(patch)
        .then (data)->
          angular.extend $scope.me, data
          angular.extend $scope.oldMe, data
          notify
            message:'已保存'
            template:'components/alert/success.html'
          $scope.me

    onFileSelect: ($event, files)->
      console.log files
      if files?.length
        $modal.open
          templateUrl: 'app/imageCrop/imageCropPopup.html'
          controller: 'ImageCropPopupCtrl'
          resolve:
            files: -> files
            options: ->
              maxWidth: 128
              ratio: 1
        .result.then (url,raw)->
          # file is uploaded successfully
          $scope.me.avatar = url
          $scope.patchMe('avatar')
          .then (user)->
            Auth.getCurrentUser().avatar = user.avatar
            $scope.isUploading = false
        , ()->
          console.log 'dismiss'
          console.log $event

    isUploading: false

  $scope.getMyProfile()




