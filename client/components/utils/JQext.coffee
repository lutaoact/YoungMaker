((_$) ->
  _$.fn.scrollParent = ()->
    parent = this.parents().filter (index,el)->
      $(el).css('overflow') is 'auto'
    if parent and parent.length
      parent = $(parent[0])
    else
      parent = $(document)
    parent
)($)
