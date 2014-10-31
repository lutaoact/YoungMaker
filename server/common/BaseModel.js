var AsyncClass = require('./AsyncClass').AsyncClass;
var mongoose;
var models = {};
var createdModifiedPlugin = require('mongoose-createdmodified').createdModifiedPlugin;

var methods = [
    // mongoose.Model static
    'remove', 'ensureIndexes', 'find', 'findById', 'findOne', 'count', 'distinct',
    'findOneAndUpdate', 'findByIdAndUpdate', 'findOneAndRemove', 'findByIdAndRemove',
    'create', 'update', 'mapReduce', 'aggregate', 'populate',
    'geoNear', 'geoSearch',
    // mongoose.Document static
    'update'
];

var body = {
    classname : 'BaseModel',
    model: null,
    mongoose: null,
    schema: null,
    schemaParams: {},
    dbURL : '',

    initialize : function() {
        if(_.isEmpty(mongoose)){
//            mongoose = require('mongoose');
            mongoose = require('mongoose-q')(null, {spread: true});
            var dbURL = this.dbURL || config.mongo.uri;
            var connection = mongoose.connect(dbURL, config.mongo.options).connection;

            connection.on('error', function(err) {
                console.log('connection error:' + err);
            });

            connection.once('open', function() {
                console.log('open mongodb success');
            });
        }

        this.mongoose = mongoose;

        if (this.schema) {
            this.createModel(_u.convertToSnakeCase(this.classname));
        }
    },

    createModel : function(name){
        if (name !== 'invert_index') {
          this.schema.plugin(createdModifiedPlugin, {index: true});
        }
        if(!models[name]) {
            models[name] = mongoose.model(name, this.schema);
        }

        this.model = models[name];
        return this.model;
    },
};

_.each(methods, function(method) {
  body[method] = function() {
    return this.model[method].apply(this.model, arguments);
  };

  var methodQ = method + 'Q';
  body[methodQ] = function() {
    return this.model[methodQ].apply(this.model, arguments);
  };
});

exports.BaseModel = AsyncClass.subclass(body);
