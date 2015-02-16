use warnings;
use strict;

#die 'model name is needed' if @ARGV < 1;

my $name = "banner";
my $model = ucfirst $name;

my $API_DIR = "server/api";

#print sprintf controller_tmpl(), $model, $name, $model;
#print sprintf index_tmpl(), $name;
#print sprintf model_tmpl(), $model, $model, $model;

my $model_dir = "$API_DIR/$name";

unless (-d $model_dir) {
  mkdir $model_dir or die $!;
}

write_file(
  "$model_dir/$name.controller.coffee",
  sprintf controller_tmpl(), $model, $name, $model
);

write_file(
  "$model_dir/$name.model.coffee",
  sprintf model_tmpl(), $model, $model, $model
);

write_file(
  "$model_dir/index.coffee",
  sprintf index_tmpl(), $name
);

print "create model success: $name\n";


sub controller_tmpl {
  return <<'HERE';
"use strict"
%s = _u.getModel '%s'

WrapRequest = new (require '../../utils/WrapRequest')(%s)

exports.index = (req, res, next) ->
  conditions = {}
  WrapRequest.wrapIndex req, res, next, conditions

exports.show = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapIndex req, res, next, conditions

pickedKeys = []
exports.create = (req, res, next) ->
  data = _.pick req.body, pickedKeys
  WrapRequest.wrapCreate req, res, next, data

pickedUpdatedKeys = []
exports.update = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys

exports.destroy = (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapDestroy req, res, next, conditions
HERE
}

sub index_tmpl {
  return <<'HERE';
"use strict"

express = require("express")
controller = require("./%s.controller")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", controller.index
router.get "/:id", auth.hasRole('admin'), controller.show
router.post "/", auth.hasRole('admin'), controller.create
router.put "/:id", auth.hasRole('admin'), controller.update
router.patch "/:id", auth.hasRole('admin'), controller.update
router.delete "/:id", auth.hasRole('admin'), controller.destroy

module.exports = router
HERE
}

sub model_tmpl {
  return <<'HERE';
BaseModel = require '../../common/BaseModel'
mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

class %s extends BaseModel
  populates: {
  }

  schema: new Schema

exports.Class = %s
exports.Instance = new %s()
HERE
}

sub write_file {
    my ($file, $text) = @_;
    open my $fh, '>', $file or die "$!";
    print $fh $text;
    close $fh;
}
