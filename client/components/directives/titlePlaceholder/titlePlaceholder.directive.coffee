angular.module('maui.components')

.directive 'titlePlaceholder', ($timeout) ->
  require: '?ngModel'
  link: (scope, element, attr, ngModel) ->
    placeholder = attr.titlePlaceholder
    phEl = $("<p class=\"title-placeholder\">#{placeholder}</p>")
    element.before phEl
    ngModel.$render = ()->
      if ngModel?.$viewValue
        phEl.addClass 'title'
      else
        phEl.removeClass 'title'
      element.val(ngModel.$modelValue)
      element.change()

    element.on 'change', ->
      if ngModel?.$viewValue
        phEl.addClass 'title'
      else
        phEl.removeClass 'title'

    element.on 'focus', ->
      phEl.addClass 'title'

    element.on 'blur', ->
      if element.val()
        phEl.addClass 'title'
      else
        phEl.removeClass 'title'

