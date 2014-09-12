"use strict"

School = _u.getModel 'school'
exports.show = (req, res, next) ->
  School.findOneQ {}
  .then (school) ->
    res.send school
  , next
