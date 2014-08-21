'use strict'

###
# @ngdoc overview
# @name ui.bootstrap.projector

# @description
# AngularJS version of an image projector.
###

angular.module('budweiserApp')
.controller 'coolProjectorController', ['$scope', '$timeout', '$transition', ($scope, $timeout, $transition) ->
  self = this
  frames = self.frames = $scope.frames = []
  currentIndex = -1
  self.currentFrame = null

  destroyed = false
  # direction: "prev" or "next"
  self.select = $scope.select = (nextFrame, direction, userTriggered) ->

    nextIndex = frames.indexOf(nextFrame)

    goNext = ()->
      #  Scope has been destroyed, stop here.
      if destroyed
        return
      # If we have a frame to transition from and we have a transition type and we're allowed, go
      if self.currentFrame && angular.isString(direction) && !$scope.noTransition && nextFrame.$element
        # We shouldn't do class manip in here, but it's the same weird thing bootstrap does. need to fix sometime
        nextFrame.$element.addClass(direction)
        reflow = nextFrame.$element[0].offsetWidth; # force reflow

        # Set all other frames to stop doing their stuff for the new transition
        angular.forEach frames, (frame) ->
          angular.extend(frame, {direction: '', entering: false, leaving: false, active: false})

        angular.extend(nextFrame, {direction: direction, active: true, entering: true})
        angular.extend(self.currentFrame||{}, {direction: direction, leaving: true})

        $scope.$currentTransition = $transition(nextFrame.$element, {})
        # We have to create new pointers inside a closure since next & current will change
        ((next,current) ->
          $scope.$currentTransition.then ()->
            transitionDone(next, current)
          , ()->
            transitionDone(next, current)
        )(nextFrame, self.currentFrame)
      else
        transitionDone(nextFrame, self.currentFrame)

      self.currentFrame = nextFrame
      currentIndex = nextIndex
      # onChange callback
      if userTriggered? && $scope.onChange
        $scope.onChange(item: self.currentFrame.$parent)

      # every time you change frames, reset the timer
      restartTimer()

    transitionDone = (next, current)->
      angular.extend(next, {direction: '', active: true, leaving: false, entering: false})
      angular.extend(current||{}, {direction: '', active: false, leaving: false, entering: false})
      $scope.$currentTransition = null

    # Decide direction if it's not given
    if direction is undefined
      direction = if nextIndex > currentIndex then 'next' else 'prev'
    if nextFrame && nextFrame isnt self.currentFrame
      if $scope.$currentTransition
        $scope.$currentTransition.cancel()
        # Timeout so ng-class in template has time to fix classes for finished frame
        $timeout(goNext)
      else
        goNext()





  $scope.$on '$destroy', () ->
    destroyed = true

  # Allow outside people to call indexOf on frames array
  self.indexOfFrame = (frame) ->
    frames.indexOf(frame)

  $scope.next = () ->
    newIndex = (currentIndex + 1) % frames.length

    # Prevent this user-triggered transition from occurring if there is already one in progress
    if !$scope.$currentTransition
      return self.select(frames[newIndex], 'next', true)

  $scope.autoNext = () ->
    newIndex = (currentIndex + 1) % frames.length

    # Prevent this user-triggered transition from occurring if there is already one in progress
    if !$scope.$currentTransition
      return self.select(frames[newIndex], 'next')

  $scope.prev = () ->
    newIndex = if currentIndex - 1 < 0 then frames.length - 1 else currentIndex - 1
    # //Prevent this user-triggered transition from occurring if there is already one in progress
    if !$scope.$currentTransition
      return self.select(frames[newIndex], 'prev', true)

  $scope.isActive = (frame) ->
    return self.currentFrame is frame;

  $scope.$watch('interval', restartTimer)
  $scope.$on('$destroy', resetTimer)

  restartTimer = () ->
    resetTimer()
    interval = +$scope.interval
    if !isNaN(interval) && interval>=0
      currentTimeout = $timeout(timerFn, interval)

  resetTimer = () ->
    if currentTimeout
      $timeout.cancel(currentTimeout)
      currentTimeout = null

  timerFn = () ->
    if $scope.isPlaying
      $scope.autoNext()
      restartTimer()
    else
      $scope.pause()

  $scope.play = () ->
    if !$scope.isPlaying
      $scope.isPlaying = true
      restartTimer()

  $scope.pause = ()->
    if !$scope.noPause
      $scope.isPlaying = false
      resetTimer()

  self.addFrame = (frame, element) ->
    frame.$element = element
    frames.push(frame)
    # if this is the first frame or the frame is set to active, select it
    if frames.length is 1 || frame.active
      self.select(frames[frames.length-1])
      if frames.length == 1
        $scope.play()
    else
      frame.active = false

  self.removeFrame = (frame)->
    # //get the index of the frame inside the projector
    index = frames.indexOf(frame)
    frames.splice(index, 1)
    if frames.length > 0 && frame.active
      if index >= frames.length
        self.select(frames[index-1])
      else
        self.select(frames[index])
    else if currentIndex > index
      currentIndex--

  self
]

.directive 'coolProjector', [() ->
  restrict: 'EA',
  transclude: true,
  replace: true,
  controller: 'coolProjectorController',
  require: 'coolProjector',
  templateUrl: 'app/directives/coolProjector/coolProjector.html',
  scope:
    interval: '='
    noTransition: '='
    noPause: '='
    onChange: '&'
]

.directive 'coolFrame', () ->
  require: '^coolProjector',
  restrict: 'EA',
  transclude: true,
  replace: true,
  templateUrl: 'app/directives/coolProjector/coolFrame.html',
  scope:
    active: '=?'
  link: (scope, element, attrs, coolProjectorController) ->
    coolProjectorController.addFrame(scope, element)
    # //when the scope is destroyed then remove the frame from the current frames array
    scope.$on('$destroy', () ->
      coolProjectorController.removeFrame(scope);
    );

    scope.$watch 'active', (active) ->
      if (active)
        coolProjectorController.select(scope)



