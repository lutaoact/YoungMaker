var categories = [
  '管理系',
  '机电工程系',
  '计算机信息系',
  '汽车工程系',
  '商务系',
  '外语系',
  '珠宝与艺术设计系'
];

var org = db.organizations.findOne({uniqueName: 'xqsh'});
categories.forEach(function(category) {
  db.categories.insert({name: category, orgId: org._id});
});
