'user strict'

Classe = _u.getModel 'classe'

# object to store sockjs connections. It is built like this:
# classId: [
#   userId : xxx
#   conn : connection
# ]
# Here key is classId and value is an array of objects made of userId and conn
connectManager = {}

# save connect to connectManager
saveConnect = (conn, userId, role) ->
  Classe.findOneQ
    students : userId
  .then (classe) ->
    console.log 'Found classe for userId ' + userId
    console.dir classe
    console.dir connectManager
    console.log 'Check if class is already in connectManager'
    if not (connectManager.hasOwnProperty classe._id)
      console.log 'Add entry...'
      connectManager[classe._id] = [
        userId : userId
        role : role
        conn   : conn
      ]
    else
      console.log 'Already in entry...'
      index = _.findIndex connectManager[classe._id], (item) ->
        item.userId is userId
      if index is -1 then connectManager[classe._id].push
        userId : userId
        role : role
        conn : conn
  , (err) ->
    logger.error 'Failed to find classe'


onData = (msg) ->
  conn = this

  msg = JSON.parse msg

  switch msg.type
    when 'login'
      userId = msg.payload.userId
      role = msg.payload.role
      logger.info "receive #{userId}/#{role} login msg"
      #TODO: add authentication part here

      saveConnect conn, userId, role

    when 'quiz'
      logger.info 'receive quiz msg'

onClose = () ->
  logger.info 'Sockjs connection closed'


# send notice to given user
exports.sendNotice = (userId, notice) ->
  logger.info "Send notice #{notice} to user #{userId}"

exports.test = ->
  console.log 'Test Socket'
  _.forEach _.flatten(_.values connectManager), (au) ->
    msg = JSON.stringify
      data:
        message:'hello world'
        name:'tester'
    au.conn.write msg

# broadcast quiz to given class
exports.broadcastQuiz = (classeId, questionId) ->
  logger.info "Broadcast quiz #{questionId} to class #{classeId}"
  audiences = connectManager[classeId]
  console.log 'Audiences is '
  console.dir audiences
  _.forEach audiences, (au) ->
    logger.info "send quiz #{questionId} to user #{au.userId}"
    msg = JSON.stringify
      type : 'quiz'
      payload :
        questionId : questionId
    logger.info 'msg is ' + msg
    au.conn.write msg

# init sockjs, set up event listeners
exports.init = (sockjs) ->
  sockjs.on 'connection', (conn) ->

    conn.on 'data', onData
    conn.on 'close', onClose
