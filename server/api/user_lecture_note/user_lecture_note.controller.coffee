"use strict"

UserLectureNote = _u.getModel 'user_lecture_note'

exports.index = (req, res, next) ->
  conditions = orgId: req.user.orgId
  conditions._id = req.query.categoryId if req.query.categoryId

  UserLectureNote.findQ userId: req.user._id
  .then (userLectureNotes) ->
    res.send userLectureNotes
  , next

exports.show = (req, res, next) ->
  UserLectureNote.findByIdQ req.params.id
  .then (result) ->
    res.send result
  , next

exports.create = (req, res, next) ->
  body =
    userId: req.user._id
    lectureId: req.body.lectureId
    note: req.body.note

  UserLectureNote.createQ body
  .then (result) ->
    res.send 201, result
  , next

exports.update = (req, res, next) ->
  UserLectureNote.findByIdQ req.params.id
  .then (userLectureNote) ->
    userLectureNote.note = req.body.note
    do userLectureNote.saveQ
  .then (result) ->
    res.send result[0]
  , next

exports.destroy = (req, res, next) ->
  UserLectureNote.removeQ _id: req.params.id
  .then () ->
    res.send 204
  , next
