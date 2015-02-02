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
    group: null
    groupArticles: []

    onAvatarUploaded: (key) ->
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
      Restangular.all('articles').post
        title: '新建小组话题'
        content: ''
        group: $state.params.groupId
      .then (article) ->
        $state.go 'groupArticleEditor',
          groupId: $state.params.groupId
          articleId: article._id

    getRole: ->
      if !$scope.me._id?
        return 'passerby'
      if $scope.me._id == $scope.group?.creator._id
        return 'creator'
      else if ($scope.group?.members.indexOf $scope.me._id) >= 0
        return 'member'
      else
        return 'passerby'


  groupAPI.get().then (group) ->
    $scope.group = group

  Restangular.all('articles').getList({group: $state.params.groupId})
  .then (articles) ->
    $scope.groupArticles = articles
