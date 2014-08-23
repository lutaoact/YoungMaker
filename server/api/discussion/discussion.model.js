(function() {
  'use strict';
  var BaseModel, ObjectId, Schema, mongoose;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  ObjectId = Schema.Types.ObjectId;

  BaseModel = (require('../../common/BaseModel')).BaseModel;

  exports.Discussion = BaseModel.subclass({
    classname: 'Discussion',
    initialize: function($super) {
      this.schema = new Schema({
        userId: {
          type: ObjectId,
          ref: 'user',
          required: true
        },
        courseId: {
          type: ObjectId,
          ref: 'course',
          required: true
        },
<<<<<<< HEAD
        lectureId: {
          type: ObjectId,
          ref: 'lecture',
          required: true
        },
=======
>>>>>>> master
        content: {
          type: String,
          required: true
        },
        responseTo: {
          type: ObjectId,
          ref: 'discussion'
        },
        voteUpUsers: [
          {
            type: ObjectId,
            ref: 'user'
          }
        ],
        voteDownUsers: [
          {
            type: ObjectId,
            ref: 'user'
          }
        ]
      });
      return $super();
    }
  });

}).call(this);

//# sourceMappingURL=discussion.model.js.map
