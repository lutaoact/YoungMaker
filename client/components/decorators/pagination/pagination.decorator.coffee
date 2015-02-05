'use strict'

angular.module 'maui.components'
.config ($provide) ->
  $provide.decorator 'paginationDirective', ($delegate) ->
    # decorate the $delegate
    directive = $delegate[0]
    directive.templateUrl = 'components/decorators/pagination/pagination.html'

    compile = directive.compile
    directive.compile = (tElement, tAttrs)->
      link = compile.apply(this, arguments)
      return (scope, elem, attrs, ctrls)->
        link.apply(this, arguments)

        ngModelCtrl = ctrls[1]
        scope.selectPage = (page) ->
          if page > 0 && page <= scope.totalPages
            ngModelCtrl.$setViewValue(page)
            ngModelCtrl.$render()

    $delegate
