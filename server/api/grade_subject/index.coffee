"use strict"

express = require("express")
controller = require("./grade_subject.controller")
router = express.Router()

# get all grade_subject
router.get '/', controller.index

module.exports = router