var result = {};
db.questions.find().forEach(function(question) {
  question.keyPoints.forEach(function(keyPoint) {
    var keyPointString = keyPoint.valueOf();
    if (!result[keyPointString]) {
      result[keyPointString] = {}
    }
    if (!result[keyPointString][question.level]) {
      result[keyPointString][question.level] = [];
    }
    result[keyPointString][question.level].push(question._id.valueOf());
  });
});
db.invert_indexes.drop();
db.invert_indexes.save(result);
printjson(result);
