'use strict'

angular.module('mauiApp')

.factory 'User', ($resource) ->

  $resource '/api/users/:id/:controller',
    id: '@_id'
  ,
    get:
      method: 'GET'
      params:
        id: 'me'

