var userAnswers = db.quiz_answers.find().map(function(qa) {
  delete qa.lectureId;
  return qa;
});
//printjson(userAnswers);
db.user_answers.insert(userAnswers);
