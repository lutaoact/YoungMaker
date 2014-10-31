require './init'
Course = _u.getModel 'course'

data =
  title: 'first course'
  info : 'xxx'
  grade: '初一'
  subject: '物理'
  lectures: []
  price: 100

Course.createQ data
.then (result) ->
  console.log result
, (err) ->
  console.log err

Payment = _u.getModel 'payment'
Payment.createQ {userId: '111111111111111111111111', amount: 10}
.then (result) ->
  console.log result
, (err) ->
  console.log err
