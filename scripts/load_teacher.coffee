'use strict'
require '../server/common/init'

Organization = _u.getModel 'organization'
User = _u.getModel 'user'

teacher =
  username: "teacher1_xqsh"
  password: "teacher1_xqsh"
  email: "teacher1@xq.sh.cn"
  name: '上海新侨学院老师'
  role: 'teacher'

Organization.findOneQ uniqueName: 'xqsh'
.then (org) ->
  teacher.orgId = org._id
  User.createQ teacher
.then (teacher) ->
  console.log teacher
, (err) ->
  console.log err
