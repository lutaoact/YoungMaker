db.lectures.find().forEach(function(lecture) {
  lecture.files = [{
    fileName: 'file 1',
    fileContent: lecture.slides,
  }];
  db.lectures.update({_id: lecture._id}, lecture);
});
