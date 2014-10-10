'use strict'

angular.module('budweiserApp').directive 'compileHtml', ($timeout, $compile, $sce, $parse)->
  restrict: 'A'
  replace: true
  compile: (tElement) ->
    (scope, element, attr) ->
      element.data('$binding', attr.compileHtml);
      parsed = $parse(attr.compileHtml);

      getStringValue = () ->
        (parsed(scope) or '').toString();

      scope.$watch getStringValue, (value) ->
        element.html($sce.getTrustedHtml(parsed(scope)) or '')

