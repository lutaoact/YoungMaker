
# hack the ngSrc. ref: http://briantford.com/blog/angular-hacking-core
angular.module('maui.components')

.config ($provide, configs) ->
  # given `{{x}} y {{z}}` return `['x', 'z']`
  getExpressions = (str) ->
    offset = 0
    parts = []
    left = undefined
    right = undefined
    while (left = str.indexOf("{{", offset)) > -1 and (right = str.indexOf("}}", offset)) > -1
      parts.push str.substr(left + 2, right - left - 2)
      offset = right + 1
    parts

  $provide.decorator "ngSrcDirective", ($delegate, $parse, $timeout) ->

    # `$delegate` is an array of directives registered as `ngSrc`
    # btw, did you know you can register multiple directives to the same name?

    # the one we want is the first one.
    ngSrc = $delegate[0]
    ngSrc.compile = (element, attrs) ->
      expressions = getExpressions(attrs.ngSrc)
      getters = expressions.map($parse)
      (scope, element, attr) ->
        attr.$observe "ngSrc", (value) ->
          doSet = ->
            value = configs.baseUrl + value  if /^\/api\//.test value
            tagName = element[0].tagName
            if tagName is "SOURCE"
              attr.$set "src", value
            else if tagName is 'IMG'
              attr.$set "src", value
            else
              element.css 'background-image', "url('#{value}')"

          doSet() if getters.every((getter) ->
            getter scope
          )
          return

        return

    # our compile function above returns a linking function
    # so we can delete this
    delete ngSrc.link

    $delegate
