angular.module 'budweiserApp'
.config ($provide)->
  $provide.decorator 'taOptions',[
    'taRegisterTool'
    '$delegate'
    (taRegisterTool, taOptions)->
      # $delegate is the taOptions we are decorating
      # register the tool with textAngular
      taRegisterTool 'colourRed',
        iconclass: "fa fa-square red",
        action: ()->
          this.$editor().wrapSelection('forecolor', 'red')

      # add the button to the default toolbar definition
      taOptions.toolbar[1].push('colourRed');
      return taOptions;
    ]
  $provide.decorator 'taOptions',[
    'taRegisterTool'
    '$delegate'
    '$modal'
    (taRegisterTool, taOptions, $modal)->

      # $delegate is the taOptions we are decorating
      # register the tool with textAngular
      taRegisterTool 'upload',
        iconclass: "fa fa-image",
        action: ($deferred)->
          selection = rangy.saveSelection(window)
          self = this
          $modal.open
            templateUrl: 'app/forum/imageUpload/imageUpload.html'
            controller: 'ImageUploadCtrl'
          .result.then (result)->
            rangy.restoreSelection(selection)
            # http://placehold.it/32x32
            self.$editor().wrapSelection 'insertImage', result, true
            $deferred.resolve()
          return false

      # add the button to the default toolbar definition
      taOptions.toolbar[1].push('upload');
      return taOptions
    ]
