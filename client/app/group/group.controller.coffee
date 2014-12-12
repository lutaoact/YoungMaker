angular.module('mauiApp')

.controller 'GroupCtrl', (
  Auth
  $scope
  $state
  Restangular
  notify
) ->
  groupAPI = Restangular.one('groups', $state.params.groupId)

  angular.extend $scope,
    showEditingForm: false
    me: Auth.getCurrentUser()
    group: null

    onAvatarUploaded: (key) ->
#      $scope.editingInfo.avatar = key
      Restangular.one('groups', $scope.group._id)
      .patch avatar: key
      .then ->
        $scope.group.avatar = key
        notify
          message: '头像修改成功'
          classes: 'alert-success'
    saveDesc: (form) ->
      console.log 'wtf'
      if !form.$valid then return
      $scope.errors = null
      Restangular.one('groups', $scope.group._id)
      .patch
          description:
            $scope.group.description
      .then ->
        notify
          message: '基本信息已保存'
          classes: 'alert-success'
        $scope.showEditingForm = false
      .catch (error) ->
        $scope.errors = error?.data?.errors

    editGroupInfo: ->
      $scope.showEditingForm = true

    joinGroup: ->
      Restangular.one('groups', $scope.group._id).one('join')
      .post()
      .then ->
        $scope.role = 'member'
        notify
          message: '已加入小组'
          classes: 'alert-success'
      .catch (error) ->
        $scope.errors = error?.data?.errors

    leaveGroup: ->
      Restangular.one('groups', $scope.group._id).one('leave')
      .post()
      .then ->
        $scope.role = 'passerby'
        notify
          message: '已退出小组'
          classes: 'alert-success'
      .catch (error) ->
        $scope.errors = error?.data?.errors

    createGroupArticle: ->
      Restangular.all('articles').post
        title: '新建小组话题'
        content: ''
        group: $state.params.groupId
      .then (article) ->
        $state.go 'groupArticleEditor',
          groupId: $state.params.groupId
          articleId: article._id


  groupAPI.get().then (group) ->
    $scope.group = group

    if $scope.me._id == $scope.group.creator._id
      $scope.role = 'creator'
    else if $scope.me._id in $scope.group.members
      $scope.role = 'member'
    else
      $scope.role = 'passerby'