module.exports =
  Course:
    field: 'author'
    populate: 'name avatar info'
  Article:
    field: 'author'
    populate: 'name avatar info'
  Group:
    field: 'creator'
    populate: 'name avatar info'
