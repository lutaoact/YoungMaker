//run in mongo shell
//> load("/path/to/questions_migration.js")
var result = db.questions.update({}, {
  $rename: {
    "content.title"   : "body",
    "content.body"    : "choices",
    "solution"        : 'detailSolution'
  }
}, {multi: true});

printjson(result);

result = db.questions.update({}, {$unset: {content: ''}}, {multi: true});

printjson(result);

db.questions.find({}).forEach(function(q) {
  print(q._id);
  if (q.choices != null) {
    newChoices = q.choices.map(function(choice) {
      return {
        text: choice.desc,
        correct: choice.correct
      };
    });
    db.questions.update({_id: q._id}, {$set: {choices: newChoices}});
  }
  else {
    print('question.choices is null');
  }
});
