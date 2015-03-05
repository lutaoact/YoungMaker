( (global)->
  extend = (target, source) ->
    target = target or {}
    for prop of source
      if typeof source[prop] == 'object'
        target[prop] = extend(target[prop], source[prop])
      else
        target[prop] = source[prop]
    target

  initConfig =
    appid: 'wxc4b8ccffaa02bfb2'
    imgUrl: undefined
    lineLink: undefined
    descContent: document.location.host
    shareTitle: document.title

  wxShare =
    weixinJSBridgeReady : false

    config: extend {}, initConfig

    init: (opt)->
      extend wxShare.config, opt

    shareFriend: ->
      WeixinJSBridge.invoke 'sendAppMessage', {
        'appid': wxShare.config.appid
        'img_url': wxShare.config.imgUrl
        'img_width': '200'
        'img_height': '200'
        'link': wxShare.config.lineLink
        'desc': wxShare.config.descContent
        'title': wxShare.config.shareTitle
      }, (res) ->
      return

    shareTimeline: ->
      WeixinJSBridge.invoke 'shareTimeline', {
        'img_url': wxShare.config.imgUrl
        'img_width': '200'
        'img_height': '200'
        'link': wxShare.config.lineLink
        'desc': wxShare.config.descContent
        'title': wxShare.config.shareTitle
      }, (res) ->
        console.remote?(JSON.stringify(res))
        alert '请点击微信右上角按钮，在弹出菜单中选择分享'
      return

    shareWeibo: ->
      WeixinJSBridge.invoke 'shareWeibo', {
        'content': wxShare.config.descContent
        'url': wxShare.config.lineLink
      }, (res) ->
      return

  # 当微信内置浏览器完成内部初始化后会触发WeixinJSBridgeReady事件。
  document.addEventListener 'WeixinJSBridgeReady', ( ->
    wxShare.weixinJSBridgeReady = true
    # 发送给好友
    WeixinJSBridge.on 'menu:share:appmessage', (argv) ->
      wxShare.shareFriend()
      return
    # 分享到朋友圈
    WeixinJSBridge.on 'menu:share:timeline', (argv) ->
      wxShare.shareTimeline()
      return
    # 分享到微博
    WeixinJSBridge.on 'menu:share:weibo', (argv) ->
      wxShare.shareWeibo()
      return
    return
  ), false

  global.wxShare = wxShare
)(window)
