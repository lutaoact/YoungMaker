fs = require 'fs'

#TODO: auto reload chinese_dictionary.txt
fileContent = fs.readFileSync __dirname+'/chinese_dictionary.txt', 'utf-8'
filterWords = fileContent.toString().split('\n')
filterWords = _.without filterWords, ''
filterWords = _.uniq filterWords


testFilter = (content)->
  for filterWord in filterWords
    if content.indexOf(filterWord) >= 0
      throw
        status : 403
        errCode : ErrCode.InvalidContent
        errMsg : filterWord

module.exports = testFilter