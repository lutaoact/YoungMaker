"use strict"
mongoose = require("mongoose")
Schema = mongoose.Schema

BaseModel = require '../../common/BaseModel'

class Classe extends BaseModel
  schema: new Schema
    name:
      type: String
      required: true
    teachers: [
      type: Schema.Types.ObjectId
      ref: "user"
    ]
    students: [
      type: Schema.Types.ObjectId
      ref: "user"
    ]
    info: String

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
