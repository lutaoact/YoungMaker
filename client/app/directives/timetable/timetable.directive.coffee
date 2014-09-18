'use strict'

angular.module('budweiserApp').directive 'timetable', ($timeout)->
  templateUrl: 'app/directives/timetable/timetable.html'
  restrict: 'E'
  scope:
    eventSouces: '='
    eventClick: '&'
    dayChanged: '&'
  controller: ($scope, $document)->

    angular.extend $scope,
      onEventClick: ($event, event)->
        $scope.eventClick?()? event

      today: moment()

      selectedDay: moment()._d

      getWeek: ()->
        m = ('0' + (moment($scope.selectedDay).month() + 1)).substr(-2,2)
        startDate = moment($scope.selectedDay).startOf('week').date()
        endDate = moment($scope.selectedDay).endOf('week').date()
        "#{m}/#{startDate} - #{m}/#{endDate}"

      next: ()->
        @selectedDay = moment(@selectedDay).add(1, 'weeks')._d

      prev: ()->
        @selectedDay = moment(@selectedDay).subtract(1, 'weeks')._d

      $scope.$watch 'selectedDay', (value)->
        if value
          $scope.dayChanged()?(value)

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

.factory 'timetableHelper', ($tools)->
  genStudentTimetable: (schedules, day)->
    eventSouces = [1..5].map -> []
    today = day or moment()
    weekStart = today.clone().isoWeekday(1)
    weekEnd = today.clone().isoWeekday(5)
    schedules.forEach (schedule)->
      if moment(schedule.start).isAfter weekEnd or moment(schedule.until).isBefore weekStart
        # not shown
        console.log 'out of date'
      else
        isoWeekday =  moment(schedule.start).isoWeekday() # 1,2...7
        event = {}
        event.title = schedule.course.name
        event.$course = schedule.course
        event.color = $tools.genColor(schedule.course._id)
        event.startTime = moment(schedule.start).weeks(today.weeks())
        event.currentWeek = today.diff(moment(schedule.start),'weeks') + 1
        event.weeks = moment(schedule.until).diff(moment(schedule.start),'weeks') + 1
        event.endTime = moment(schedule.end).weeks(today.weeks())
        eventSouces[isoWeekday - 1].push event
    eventSouces

  genTeacherTimetable: (schedules, day)->
    eventSouces = [1..5].map -> []
    today = day or moment()
    weekStart = today.clone().isoWeekday(1)
    weekEnd = today.clone().isoWeekday(5)
    schedules.forEach (schedule)->
      if moment(schedule.start).isAfter weekEnd or moment(schedule.until).isBefore weekStart
        # not shown
        console.log 'out of date'
      else
        isoWeekday =  moment(schedule.start).isoWeekday() # 1,2...7
        event = {}
        event.title = schedule.course.name
        event.subtitle = [schedule.classe.yearGrade, schedule.classe.name].join(' ')
        event.$course = schedule.course
        event.startTime = moment(schedule.start).weeks(today.weeks())
        # event.currentWeek = today.diff(moment(schedule.start),'weeks') + 1
        # event.weeks = moment(schedule.until).diff(moment(schedule.start),'weeks') + 1
        event.endTime = moment(schedule.end).weeks(today.weeks())
        eventSouces[isoWeekday - 1].push event
    eventSouces
