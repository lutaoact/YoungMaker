###
 * Using Rails-like standard naming convention for endpoints.
 * GET     /grade_subjects           ->  index
 * DELETE  /discussions/:id          ->  destroy
 ###

'use strict'

GradeSubject = _u.getModel 'grade_subject'

exports.index = (req, res, next) ->
  GradeSubject.findQ()
  .then (gs) ->
    res.send gs
  .catch next
  .done()