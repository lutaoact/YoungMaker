db.questions.find().forEach(function(question) {
  db.questions.update({_id: question._id}, {$set: {level: Math.ceil(Math.random() * 100)}});
});
