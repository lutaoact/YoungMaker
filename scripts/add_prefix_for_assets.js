//load("/path/to/add_prefix_for_assets.js")
db.users.find({avatar: {$ne: null}}).forEach(function(user) {
    db.users.update({_id: user._id}, {$set: {avatar: user.avatar.replace(/((?:\/\w+){3})/, "$1/0")}});
});

db.courses.find({thumbnail: {$ne: null}}).forEach(function(course) {
  db.courses.update({_id: course._id}, {$set: {thumbnail: course.thumbnail.replace(/((?:\/\w+){3})/, "$1/0")}});
});

db.lectures.find().forEach(function(lecture) {
  if (lecture.thumbnail) {
    lecture.thumbnail = lecture.thumbnail.replace(/((?:\/\w+){3})/, "$1/0")
  }
  if (lecture.slides.length > 0) {
    lecture.slides.forEach(function(slide) {
      slide.raw   = slide.raw.replace(/((?:\/\w+){3})/, "$1/1")
      slide.thumb = slide.thumb.replace(/((?:\/\w+){3})/, "$1/1")
    });
  }
  if (lecture.media) {
    lecture.media = lecture.media.replace(/((?:\/\w+){3})/, "$1/2")
  }
  db.lectures.update({_id: lecture._id}, lecture);
});
