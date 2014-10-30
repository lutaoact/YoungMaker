require '../../common/init'

Classe = _u.getModel 'classe'
Classe.getAllStudents ['444444444444444444444400', '444444444444444444444401']
.then (studentIds) ->
  console.log studentIds
, (err) ->
  console.log err
