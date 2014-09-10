(function() {
  'user strict';
  var Classe, connectManager, onClose, onData, saveConnect;

  Classe = _u.getModel('classe');

  connectManager = {};

  saveConnect = function(conn, userId, role) {
    return Classe.findOneQ({
      students: userId
    }).then(function(classe) {
      var audience;
      console.log('Found classe for userId ' + userId);
      console.dir(classe);
      console.dir(connectManager);
      console.log('Check if class is already in connectManager');
      if (!(connectManager.hasOwnProperty(classe._id))) {
        console.log('Add entry...');
        return connectManager[classe._id] = [
          {
            userId: userId,
            role: role,
            conn: conn
          }
        ];
      } else {
        console.log('Already in entry...');
        audience = _.find(connectManager[classe._id], {
          userId: userId
        });
        if (audience) {
          return audience.conn = conn;
        } else {
          return connectManager[classe._id].push({
            userId: userId,
            role: role,
            conn: conn
          });
        }
      }
    }, function(err) {
      return logger.error('Failed to find classe');
    });
  };

  onData = function(msg) {
    var conn, role, userId;
    conn = this;
    msg = JSON.parse(msg);
    switch (msg.type) {
      case 'login':
        userId = msg.payload.userId;
        role = msg.payload.role;
        logger.info("receive " + userId + "/" + role + " login msg");
        return saveConnect(conn, userId, role);
      case 'quiz':
        return logger.info('receive quiz msg');
    }
  };

  onClose = function() {
    return logger.info('Sockjs connection closed');
  };

  exports.sendNotice = function(userId, notice) {
    return logger.info("Send notice " + notice + " to user " + userId);
  };

  exports.test = function(msg) {
    console.log("Test Socket: " + msg);
    console.log(connectManager);
    return _.forEach(_.flatten(_.values(connectManager)), function(au) {
      var jsonResult;
      jsonResult = JSON.stringify({
        payload: {
          name: 'tester',
          message: msg
        },
        type: 'test'
      });
      return au.conn.write(jsonResult);
    });
  };

  exports.broadcastQuiz = function(classeId, questionId) {
    var audiences;
    logger.info("Broadcast quiz " + questionId + " to class " + classeId);
    audiences = connectManager[classeId];
    console.log('Audiences is ');
    console.dir(audiences);
    return _.forEach(audiences, function(au) {
      var msg;
      logger.info("send quiz " + questionId + " to user " + au.userId);
      msg = JSON.stringify({
        type: 'quiz',
        payload: {
          questionId: questionId
        }
      });
      logger.info('msg is ' + msg);
      return au.conn.write(msg);
    });
  };

  exports.init = function(sockjs) {
    return sockjs.on('connection', function(conn) {
      conn.on('data', onData);
      return conn.on('close', onClose);
    });
  };

}).call(this);

//# sourceMappingURL=sockjs_srv.js.map
