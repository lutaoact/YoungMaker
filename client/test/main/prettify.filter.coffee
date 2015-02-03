angular.module 'mauiTestApp'

.filter 'prettify', ($sce) ->
  (jsonObject) ->
    return '' if !jsonObject?
    matchType = /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g
    result = JSON.stringify(jsonObject, undefined, 4)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace matchType,  (match) ->
      className =
        if  /^"/.test(match)
          if /:$/.test(match) then 'key' else 'string'
        else if /true|false/.test(match)
          'boolean'
        else if /null/.test(match)
          'null'
        else
          'number'
      "<span class='prettify-#{className}'>#{match}</span>"
    return $sce.trustAsHtml(result)
