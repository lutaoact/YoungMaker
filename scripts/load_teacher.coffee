'use strict'
require '../server/common/init'

if process.argv.length < 3
  console.log "注意看用法："
  console.log "Usage: coffee load_teacher.coffee [orgUniqueName]"
  process.exit 1

orgUniqueName = process.argv[2]

teacherInfo = require "#{__dirname}/#{orgUniqueName}_teacher_info.json"

buildTeacherData = (teacherInfo, orgId) ->
  return (for id, name of teacherInfo
    username: "#{id}_#{orgUniqueName}"
    password: "#{id}_#{orgUniqueName}"
    name: name
    orgId: orgId
    role: 'teacher'
  )

Organization = _u.getModel 'organization'
User = _u.getModel 'user'

Organization.findOneQ uniqueName: orgUniqueName
.then (org) ->
  teacherData = buildTeacherData teacherInfo, org._id
  User.createQ teacherData
.then (teachers) ->
  console.log teachers
, (err) ->
  console.log err
