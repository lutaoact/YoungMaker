"use strict"
mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = (require '../../common/BaseModel').BaseModel

exports.Classe = BaseModel.subclass
  classname: 'Classe'
  initialize: ($super) ->
    @schema = new Schema
      name:
        type: String
        required: true
        unique: true
      orgId:
        type: Schema.Types.ObjectId
        ref: "organization"
      students: [
        type: Schema.Types.ObjectId
        ref: "user"
      ]
      yearGrade: String

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
