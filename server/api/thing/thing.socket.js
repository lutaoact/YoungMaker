/**
 * Broadcast updates to client when the model changes
 */

'use strict';
require('../../common/init');

//var thing = _u.getModel "thing"
var thing = _u.getModel('thing');

exports.register = function(socket) {
  thing.schema.post('save', function (doc) {
    onSave(socket, doc);
  });
  thing.schema.post('remove', function (doc) {
    onRemove(socket, doc);
  });
}

function onSave(socket, doc, cb) {
  socket.emit('thing:save', doc);
}

function onRemove(socket, doc, cb) {
  socket.emit('thing:remove', doc);
}
