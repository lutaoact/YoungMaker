(function() {
  "use strict";
  var auth, controller, discController, express, router;

  express = require("express");

  controller = require("./course.controller");

  auth = require("../../auth/auth.service");

  router = express.Router();

  discController = require('../discussion/discussion.controller');

  router.get("/", auth.hasRole("teacher"), controller.index);

  router.get("/:id", auth.isAuthenticated(), controller.show);

  router.post("/", auth.hasRole("teacher"), controller.create);

  router.put("/:id", auth.hasRole("teacher"), controller.update);

  router.patch("/:id", auth.hasRole("teacher"), controller.update);

  router.get("/:id/lectures", auth.isAuthenticated(), controller.showLectures);

  router.get("/:id/lectures/:lectureId", auth.isAuthenticated(), controller.showLecture);

  router.post("/:id/lectures", auth.hasRole("teacher"), controller.createLecture);

  router.put("/:id/lectures/:lectureId", auth.hasRole("teacher"), controller.updateLecture);

  router.patch("/:id/lectures/:lectureId", auth.hasRole("teacher"), controller.updateLecture);

  router["delete"]("/:id/lectures/:lectureId", auth.hasRole("teacher"), controller.destroyLecture);

  router.get("/:id/lectures/:lectureId/knowledge_points", controller.showKnowledgePoints);

  router.post("/:id/lectures/:lectureId/knowledge_points", auth.hasRole("teacher"), controller.createKnowledgePoint);

  router["delete"]('/:id', auth.hasRole('teacher'), controller.destroy);

  router.post('/:courseId/discussions', auth.isAuthenticated(), discController.create);

  router.get('/:courseId/discussions', auth.isAuthenticated(), discController.index);

  router.get('/:courseId/discussions/:id', auth.isAuthenticated(), discController.show);

  router.put('/:courseId/discussions/:id', auth.isAuthenticated(), discController.update);

  router.patch('/:courseId/discussions/:id', auth.isAuthenticated(), discController.update);

  router["delete"]('/:courseId/discussions/:id', auth.isAuthenticated(), discController.destroy);

  router.post('/:courseId/discussions/:id/votes', auth.isAuthenticated(), discController.vote);

  module.exports = router;

}).call(this);

//# sourceMappingURL=index.js.map
