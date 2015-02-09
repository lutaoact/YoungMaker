angular.module('mauiApp')

.controller 'GroupDetailCtrl', (
  Auth
  $scope
  $state
  Restangular
  notify
) ->
  groupAPI = Restangular.one('groups', $state.params.groupId)

  angular.extend $scope,
    showEditingForm: false
    group: null
#    groupArticles: []

#    pageConf:
#      maxSize      : 5
#      currentPage  : $state.params.page ? 1
#      itemsPerPage : 3

    onAvatarUploaded: (key) ->
      console.log key
      Restangular.one('groups', $scope.group._id)
      .patch avatar: key
      .then ->
        $scope.group.avatar = key
        notify
          message: '头像修改成功'
          classes: 'alert-success'

    saveDesc: (form) ->
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
      .then (data)->
        $scope.group = data
        notify
          message: '已加入小组'
          classes: 'alert-success'
      .catch (error) ->
        $scope.errors = error?.data?.errors

    leaveGroup: ->
      Restangular.one('groups', $scope.group._id).one('leave')
      .post()
      .then (data)->
        $scope.group = data
        notify
          message: '已退出小组'
          classes: 'alert-success'
      .catch (error) ->
        $scope.errors = error?.data?.errors

    createGroupArticle: ->
      if $scope.getRole() == 'passerby'
        notify
          message: '加入小组后才能发言'
          classes: 'alert-danger'
        return
      $state.go 'groupArticleNew', {groupId: $scope.group._id}

    getRole: ->
      if !$scope.me._id?
        return 'passerby'
      if $scope.me._id == $scope.group?.creator?._id
        return 'creator'
      else if ($scope.group?.members.indexOf $scope.me._id) >= 0
        return 'member'
      else
        return 'passerby'

  groupAPI.get().then (group) ->
    $scope.group = group

  Restangular.one('groups', $state.params.groupId).one('members')
  .get()
  .then (members)->
    console.log 'members'
    console.log members
    $scope.groupMembers = members