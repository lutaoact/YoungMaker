angular.module 'maui.components'
.config ($provide)->
  imgOnSelectAction = (event, $element, editorScope)->
    finishEdit = ()->
      editorScope.updateTaBindtaTextElement()
      editorScope.hidePopover()

    event.preventDefault()
    editorScope.displayElements.popover.css 'width', '375px'
    container = editorScope.displayElements.popoverContainer
    container.empty()
    buttonGroup = angular.element '<div class="btn-group" style="padding-right: 6px;">'

    fullButton = angular.element '<button type="button" class="btn btn-default btn-sm btn-small" unselectable="on" tabindex="-1">100% </button>'
    fullButton.on 'click', (event)->
      event.preventDefault()
      $element.removeClass 'half'
      $element.removeClass 'quarter'
      $element.addClass 'full'
      finishEdit()

    halfButton = angular.element '<button type="button" class="btn btn-default btn-sm btn-small" unselectable="on" tabindex="-1">50% </button>'
    halfButton.on 'click', (event)->
      event.preventDefault()
      $element.removeClass 'full'
      $element.removeClass 'quarter'
      $element.addClass 'half'
      finishEdit()

    quartButton = angular.element '<button type="button" class="btn btn-default btn-sm btn-small" unselectable="on" tabindex="-1">25% </button>'
    quartButton.on 'click', (event)->
      event.preventDefault()
      $element.removeClass 'full'
      $element.removeClass 'half'
      $element.addClass 'quarter'
      finishEdit()

    resetButton = angular.element '<button type="button" class="btn btn-default btn-sm btn-small" unselectable="on" tabindex="-1">Reset</button>'
    resetButton.on 'click', (event)->
      event.preventDefault()
      $element.removeClass 'full'
      $element.removeClass 'half'
      $element.removeClass 'quarter'
      finishEdit()

    buttonGroup.append fullButton
    buttonGroup.append halfButton
    buttonGroup.append quartButton
    buttonGroup.append resetButton
    container.append buttonGroup

    buttonGroup = angular.element '<div class="btn-group" style="padding-right: 6px;">'
    floatLeft = angular.element '<button type="button" class="btn btn-default btn-sm btn-small" unselectable="on" tabindex="-1"><i class="fa fa-align-left"></i></button>'
    floatLeft.on 'click', (event)->
      event.preventDefault()
      $element.removeClass 'pull-right'
      $element.removeClass 'center'
      $element.addClass 'pull-left'
      finishEdit()

    floatRight = angular.element '<button type="button" class="btn btn-default btn-sm btn-small" unselectable="on" tabindex="-1"><i class="fa fa-align-right"></i></button>'
    floatRight.on 'click', (event)->
      event.preventDefault()
      $element.removeClass 'pull-left'
      $element.removeClass 'center'
      $element.addClass 'pull-right'
      finishEdit()

    floatNone = angular.element '<button type="button" class="btn btn-default btn-sm btn-small" unselectable="on" tabindex="-1"><i class="fa fa-align-justify"></i></button>'
    floatNone.on 'click', (event)->
      event.preventDefault()
      $element.removeClass 'pull-left'
      $element.removeClass 'pull-right'
      $element.addClass 'center'
      finishEdit()

    buttonGroup.append floatLeft
    buttonGroup.append floatNone
    buttonGroup.append floatRight
    container.append buttonGroup

    buttonGroup = angular.element '<div class="btn-group">'
    remove = angular.element '<button type="button" class="btn btn-default btn-sm btn-small" unselectable="on" tabindex="-1"><i class="fa fa-trash-o"></i></button>'
    remove.on 'click', (event)->
      event.preventDefault()
      $element.remove()
      finishEdit()

    buttonGroup.append remove
    container.append buttonGroup

    editorScope.showPopover $element
    editorScope.showResizeOverlay $element

  $provide.decorator 'taOptions',[
    'taRegisterTool'
    '$delegate'
    '$modal'
    'fileUtils'
    'notify'
    (taRegisterTool, taOptions, $modal, fileUtils,notify)->

      taRegisterTool 'code',
        iconclass: "fa fa-code"
        action: ()->
          this.$editor().wrapSelection("formatBlock", "<PRE>")

        activeState: ()->
          this.$editor().queryFormatBlockState('pre')

      #image Uploader
      taRegisterTool 'upload',
        iconclass: "fa fa-image",
        action: ($deferred)->
          selection = rangy.saveSelection(window)
          self = this
          $modal.open
            templateUrl: 'components/modals/imageCrop/imageCropPopup.html'
            controller: 'ImageCropPopupCtrl'
            backdrop: 'static'
            resolve:
              files: -> null
              options: ->
                maxWidth: 1000
          .result.then (result)->
            rangy.restoreSelection(selection)
            embed = "<img class=\"image-zoom\" src=\"#{result}\">"
            self.$editor().wrapSelection 'insertHTML', embed, true
            $deferred.resolve()
          false

        onElementSelect:
          element: 'img'
          action: imgOnSelectAction

      taOptions.toolbar = [
        ['h1', 'h2', 'h3'],
        ['bold', 'italics', 'clear'],
        ['justifyLeft','justifyCenter','justifyRight'],
        ['ul', 'ol','code', 'quote']
        ['insertLink', 'upload']
      ]

      taOptions.defaultFileDropHandler = (file, insertAction)->
        if file.type.substring(0, 5) is 'image'
          fileUtils.uploadFile
            files: [file]
            options:
              maxWidth: 1000
            success: (url)->
              insertAction('insertImage', url, true)
            fail: (err)->
              notify
                message: err
        else
          notify
            message: '文件格式不支持'
        false

      taOptions
    ]

