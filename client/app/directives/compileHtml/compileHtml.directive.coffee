'use strict'

angular.module('mauiApp').directive 'compileHtml', ($timeout, $compile, $sce, $parse)->
  restrict: 'A'
  compile: (tElement) ->
    (scope, element, attr) ->
      element.data('$binding', attr.compileHtml);
      parsed = $parse(attr.compileHtml);

      getStringValue = () ->
        (parsed(scope) or '').toString();

      scope.$watch getStringValue, (value) ->
        element.html($sce.getTrustedHtml(parsed(scope)) or '')
        $compile(element.contents())(scope)

