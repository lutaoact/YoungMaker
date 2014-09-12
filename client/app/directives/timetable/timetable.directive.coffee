'use strict'

angular.module('budweiserApp').directive 'timetable', ($timeout)->
  templateUrl: 'app/directives/timetable/timetable.html'
  restrict: 'E'
  scope:
    eventSouces: '='
    eventClick: '&'
  controller: ($scope, $document)->

    angular.extend $scope,
      onEventClick: ($event, event)->
        $scope.eventClick?()? event

      today: moment()

      selectedDay: moment()._d

      getWeek: ()->
        m = moment($scope.selectedDay).month()
        startDate = moment($scope.selectedDay).startOf('week').date()
        endDate = moment($scope.selectedDay).endOf('week').date()
        "#{m}/#{startDate} - #{m}/#{endDate}"

  link: (scope, element, attrs) ->
    # will be init after this.
    datepicker = undefined
    overlay = element.find('.overlay')
    calendarToggle = element.find('.calendar-toggle')
    overlay.hide()

    openPopupHandle = ()->
      overlay.unbind 'click', closePopupHandle
      datepicker ?= element.find('.datepicker')
      datepicker.fadeIn('fast')
      overlay.show()
      calendarToggle.addClass('active')
      overlay.bind 'click', closePopupHandle

    closePopupHandle = ()->
      datepicker ?= element.find('.datepicker')
      datepicker.fadeOut('fast')
      overlay.hide()
      calendarToggle.removeClass('active')
      overlay.unbind 'click', closePopupHandle

    calendarToggle.bind 'click', openPopupHandle
