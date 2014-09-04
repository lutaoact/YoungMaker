(function() {
  'user strict';
  var onClose, onData;

  onData = function(msg) {
    return console.log(msg);
  };

  onClose = function() {
    return console.log('Sockjs connection closed');
  };

  module.exports = function(sock_srv) {
    return sock_srv.on('connection', function(conn) {
      console.log('Sockjs connection is...');
      console.dir(conn);
      conn.on('data', function(msg) {
        return console.log(msg);
      });
      return conn.on('close', onClose);
    });
  };

}).call(this);

//# sourceMappingURL=sockjs.js.map
