InvertIndex = _u.getModel 'invert_index'

class RecommendUtils
  recommendQuestions: (kpList) ->
    InvertIndex.findOneQ {name: 'kp'}, null, {lean: true}
    .then (invertIndex) ->
      questionIds = []
      for kp in kpList
        questionIds = questionIds.concat(
          _.sample(invertIndex[kp.kpId]?[kp.level], (kp.num ? 1))
        )

      return questionIds

exports.RecommendUtils = RecommendUtils
