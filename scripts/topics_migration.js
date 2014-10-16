//run in mongo shell
//> load("/path/to/topics_migration.js")

db.dis_topics.find({}).forEach(function(topic){
  print(topic.content);
  if(topic.content){
    var newContent = topic.content.replace(/<div\s+class="tag\W.*?<\/div>/g, '');
    newContent = newContent.replace(/<div\s+class="tags\W.*?<\/div>/g, '');
    print(newContent);
    db.dis_topics.update({_id: topic._id}, {$set: {content: newContent}});
  }
});
