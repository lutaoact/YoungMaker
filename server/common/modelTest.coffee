require './init'
#StatsUtils = _u.getUtils 'stats'
#StatsUtils.buildQAMap ['aaaaaaaaaaaaaaaaaaaaaa00', 'aaaaaaaaaaaaaaaaaaaaaa01']
#.then (map) ->
#  console.log map
#, (err) ->
#  console.log err

# populate Notice 的多个字段
User = _u.getModel 'User'
Notice = _u.getModel 'notice'
DisReply = _u.getModel 'dis_reply'
Notice.findOne _id: '54238bb07a8e230000585ca7'
      .populate 'data.disReply'
      .populate 'userId', '-hashedPassword -salt'
      .execQ()
#Notice.findOneQ _id: '54238bb07a8e230000585ca7'
#.then (notice) ->
#  console.log notice
#  Notice.populateQ notice, [{path: 'data.disReply'}, {path: 'userId', select: '-hashedPassword -salt'}]
##  notice.populate 'data.disReply'
##        .populateQ 'userId', '-hashedPassword -salt'
.then (notice) ->
  console.log notice
, (err) ->
  console.log err

#course =
#  name: 'xxxxx'
#  categoryId: '111111111111111111111112'
#  thumbnail: 'yyyy'
#  owners: [
#    '111111111111111111111111'
#    '222222222222222222222222'
#  ]
#
#classe =
#  name: 'classe'
#  orgId: '333333333333333333333333'
#  students: [
#    '444444444444444444444444'
#  ]
##notice
##data =
##  userId: '111111111111111111111111'
##  type: 1
##  data:
##    lectureId: '111111111111111111111112'
##    discussionId: '111111111111111111111113'
##  status: 0
#
#Course = _u.getModel 'course'
#Classe = _u.getModel 'classe'
##Course.save course, (err, res) ->
##  console.log err
##  console.log res
##Classe.save classe, (err, res) ->
##  console.log err
##  console.log res
#CourseUtils = _u.getUtils 'course'
#LectureUtils = _u.getUtils 'lecture'
#teacher =
#  role: 'teacher'
#  _id: '111111111111111111111102'
#
#courseId = '666666666666666666666600'
#
#CourseUtils.getStudentsNum teacher, courseId
#.then (num) ->
#  console.log num
#, (err) ->
#  console.log err
#CourseUtils.checkTeacher teacherId, '53f9b1cd67b02bc1220d556b'
#.then (course) ->
#  console.log course
#, (err) ->
#  console.log 'this is error'
#  console.log err
#student =
#  role: 'student'
#  _id: '53fbf7e19b43e4a2375266ff'
#

#LectureUtils.getAuthedLectureById teacher, '53fbf7e19b43e4a237526708'
#.then (lecture) ->
#  console.log lecture
#, (err) ->
#  console.log err
#CourseUtils.getAuthedCourseById user, '53f9b1cd67b02bc1220d556b'
#.then (course) ->
#  console.log course
#, (err) ->
#  console.log 'this is error'
#  console.log err
#studentId = '444444444444444444444444'
#CourseUtils.checkStudent studentId, '53f9b1cd67b02bc1220d556c'
#.then (course) ->
#  console.log course
#, (err) ->
#  console.log 'this is error'
#  console.log err

#Course.findOne
#  owners: teacherId
#, (err, res) ->
#  console.log err
#  console.log res
#init = Q.nbind require('./init'), null
#Notice = null
#init()
#.then () ->
#  Notice = modelMap['notice']
#  save = Q.nbind Notice.save, Notice
#  return save data
#.then (notice) ->
#  console.log notice
#  findOne = Q.nbind Notice.findOne, Notice
#  return findOne notice._id
#.then (findNotice) ->
#  console.log findNotice
#, (err) ->
#  console.log err
#AsyncClass = new require('./AsyncClass').AsyncClass
#
#
#AsyncClass.series
#  init: (next) ->
#    require('./init') next
#  save: (next) ->
#    Notice = modelMap['notice']
#    Notice.save data, next
#  findOne: (next, res) ->
#    Notice.findOne _id: res.save._id, next
#, (err, res) ->
#  console.log err, res
#  do process.exit
