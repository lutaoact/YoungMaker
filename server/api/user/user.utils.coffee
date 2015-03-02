BaseUtils = require '../../common/BaseUtils'

User = _u.getModel 'user'
Course = _u.getModel 'course'

class UserUtils extends BaseUtils
  check: (userInfo) ->
    User.findBy userInfo
    .then (user) ->
      if user?
        return Q.reject
          status : 400
          errCode : ErrCode.UserEmailInUsed
          errMsg : '该Email已被使用'

  # 如果名字可用，则直接返回，否则，拼接时间戳
  getAcceptName: (name) ->
    User.findOneQ {name: name}
    .then (doc) ->
      if doc
        return name + _u.time().toString()
      else
        return name

  multiDelete: (user, ids) ->
    if _.contains ids, user.id
      return Q.reject
        status: 403
        errCode: ErrCode.DeleteAdmin
        errMsg: 'should not delete admin self'

    conditions =
      orgId: user.orgId
      _id: $in: ids

    tmpResult = {}
    User.getIdAndRold conditions
    .then (users) =>
      [students, teachers] = @classifyStudentAndTeacher users
      console.log students, teachers
      Q.all [
        @removeStudents students
        @removeTeachers teachers
      ]
    .then (result) ->
      #result包含被修改的classes列表和courses列表
      #客户端只需要第一个字段，即classes
      tmpResult.classes = result[0]

      User.removeQ conditions
    .then () ->
      return tmpResult.classes

  removeTeachers: (ids) ->
    tmpResult = {}
    Course.findQ
      owners: $in: ids
    .then (courses) ->
      tmpResult.courses = courses
      promises = _.map courses, (course) ->
        course.owners.pull.apply course.owners, ids
        return do course.saveQ
      Q.all promises
    .then () ->
      return tmpResult.courses


  classifyStudentAndTeacher: (users) ->
    students = []
    teachers = []
    _.each users, (u) ->
      switch u.role
        when 'teacher' then teachers.push u._id
        when 'student' then students.push u._id

    return [students, teachers]


#exports.UserUtils = UserUtils
exports.Instance = new UserUtils()
exports.Class = UserUtils
