angular.module 'budweiserApp'
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
    (taRegisterTool, taOptions, $modal)->
      safeColors = [
        '#EF9D97', '#F7ED3C','#BEE4F9','#C9E1A6','#CEB5D6','#D5D2D1'
        '#EA573E', '#F7C900','#749CD2','#94C85B','#A581B8','#615C5A'
        '#E8412F', '#EF7D31','#3963AE','#69B82E','#7E509D','#24201F'
        '#C4111A', '#EA4D23','#00398A','#138336','#5A1E73','#000000'
      ]
      safeColorsHtml = safeColors.map (color)->
        "<i class='fa fa-square' style='color:#{color}'></i>"
      .join ''

      # Color picker
      taRegisterTool 'fontColour',
        display: "<span id='colorboard-btn' class='barBtn' dropdown ng-class='displayActiveToolClass(active)' ng-disabled='showHtml()'><span class='dropdown-toggle'><i class='fa fa-square'></i></span><div class='color-board dropdown-menu'>" + safeColorsHtml + "</div></span>"
        action: ($deferred)->
          self = this
          colorboardBtn = angular.element('#colorboard-btn')
          colorIcons = colorboardBtn.find('.color-board .fa-square')

          colorIconsClickHandle = (event)->
            color = event.currentTarget.style.color
            self.$editor().wrapSelection('forecolor', color)

          colorIcons.off()
          colorIcons.on 'click', colorIconsClickHandle

        activeState: (commonElement)->
          if commonElement and commonElement[0].tagName is 'FONT'
            angular.element('#colorboard-btn').css 'color', commonElement[0].color
            true
          else
            angular.element('#colorboard-btn').css 'color', '#000'
            false

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
            templateUrl: 'app/imageCrop/imageCropPopup.html'
            controller: 'ImageCropPopupCtrl'
            resolve:
              files: -> null
              options: ->
                maxWidth: 640
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
        ['fontColour','h1', 'h2', 'h3'],
        ['bold', 'italics', 'underline', 'strikeThrough', 'clear'],
        ['justifyLeft','justifyCenter','justifyRight'],
        ['ul', 'ol','code', 'quote']
        ['insertLink', 'upload']
      ]
      taOptions
    ]

