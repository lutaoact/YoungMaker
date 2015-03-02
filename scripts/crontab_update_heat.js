//参考算法：http://www.zhihu.com/question/19936651
var baseTimestamp = new Date('2015-03-01 00:00:00').getTime() / 1000 | 0;
var period = 86400 * 7; //3天
var likeWeight = 500, commentWeight = 200, viewWeight = 100;
var logBase = 10;
db.articles.find().forEach(function(doc) {
  var timeSpan = (doc.created.getTime() / 1000 | 0) - baseTimestamp;
  var Z = doc.likeUsers.length * likeWeight + ~~doc.commentsNum * commentWeight + ~~doc.viewersNum * viewWeight;
  var part1 = Z === 0 ? 0 : Math.log(Z) / Math.log(logBase);
  var part2 = timeSpan / period;
  var heat = ~~((part1 + part2) * 1000);
  print(["articleId: " + doc._id, "part1: " + part1, "part2: " + part2, "heat: " + heat].join(', '));
  db.articles.update({_id: doc._id}, {$set: {heat: heat}});
});

db.courses.find().forEach(function(doc) {
  var timeSpan = (doc.created.getTime() / 1000 | 0) - baseTimestamp;
  var Z = doc.likeUsers.length * likeWeight + ~~doc.commentsNum * commentWeight + ~~doc.viewersNum * viewWeight;
  var part1 = Z === 0 ? 0 : Math.log(Z) / Math.log(logBase);
  var part2 = timeSpan / period;
  var heat = ~~((part1 + part2) * 1000);
  print(["courseId: " + doc._id, "part1: " + part1, "part2: " + part2, "heat: " + heat].join(', '));
  db.courses.update({_id: doc._id}, {$set: {heat: heat}});
});
