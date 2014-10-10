db.categories.update({}, {$set: {orgId: db.organizations.findOne({uniqueName: 'xqsh'})._id }}, {multi: true});//为所有的category添加orgId字段
