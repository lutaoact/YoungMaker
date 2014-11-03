"use strict"
mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = require '../../common/BaseModel'

class Classe extends BaseModel
  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
      orgId:
        type: Schema.Types.ObjectId
        ref: "organization"
      students: [
        type: Schema.Types.ObjectId
        ref: "user"
      ]
      yearGrade: String

    @schema
    .path 'name'
    .validate (name, respond) ->
      self = this
      this.constructor.findOne
        name : name
        orgId: self.orgId
      , (err, data) ->
        throw err if err
        notTaken = !data or data.id == self.id
        respond notTaken
    , '该班级名称已被占用，请选择其他名称'

    $super()

  getAllStudents: (classeIds) ->
    @findQ _id: $in: classeIds
    .then (classes) ->
      return _.reduce classes, (studentIds, classe) ->
        return studentIds.concat classe.students
      , []

  # return [id & name]
  getAllStudentsInfo: (classeIds) ->
    @find _id: $in: classeIds
    .populate('students', '_id username name')
    .execQ()
    .then (classes) ->
      return _.reduce classes, (studentInfos, classe) ->
        return studentInfos.concat classe.students
      , []

exports.Class = Classe
exports.Instance = nwe Classe()
