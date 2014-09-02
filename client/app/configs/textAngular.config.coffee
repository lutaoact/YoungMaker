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
    (taRegisterTool, taOptions)->
      # $delegate is the taOptions we are decorating
      # register the tool with textAngular
      taRegisterTool 'upload',
        iconclass: "fa fa-image",
        action: ()->
          console.log 'upload'

      # add the button to the default toolbar definition
      taOptions.toolbar[1].push('colourRed');
      return taOptions;
    ]
