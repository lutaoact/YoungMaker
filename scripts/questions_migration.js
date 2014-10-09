//run in mongo shell
//> load("/path/to/questions_migration.js")
var result = db.questions.update({}, {
  $rename: {
    "content.title"   : "body",
    "content.body"    : "options",
    "solution"        : 'detailSolution',
  },
}, {multi: true});

printjson(result);

result = db.questions.update({}, {$unset: {content: ''}}, {multi: true});

printjson(result);

db.questions.find({}).forEach(function(q) {
  print(q._id);
  newOptions = q.options.map(function(option) {
    return {
      choice: option.desc,
      correct: option.correct,
    };
  });
  db.questions.update({_id: q._id}, {$set: {options: newOptions}});
});
