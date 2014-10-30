gulp = require('gulp')

$ = require('gulp-load-plugins')
  pattern: ['gulp-*', 'main-bower-files', 'uglify-save-license']


gulp.task 'default', ->
  # place code for your default task here
  console.log 'default'

gulp.task 'clean', ()->
  gulp.src ['.tmp', 'dist'], { read: false }
  .pipe $.rimraf()

gulp.task 'copy:index', ->

gulp.task 'copy', ['copy:index','copy:styles']

gulp.task 'serve', [
  'clean'
  'copy:index'
  'env:all'
  'injector:less'
  'concurrent:server'
  'injector'
  'replace'
  'processhtml'
  'bowerInstall'
  'autoprefixer'
  'express:dev'
  'wait'
  'open'
  'watch'
]
gulp.task 'serve:dist', [
  'build'
  'env:all'
  'env:prod'
  'express:prod'
  'open'
  'express-keepalive'
]

gulp.task 'build', [
  'clean'
  'copy:index'
  'injector:less'
  'concurrent:dist'
  'injector'
  'replace'
  'processhtml'
  'bowerInstall'
  'useminPrepare'
  'autoprefixer'
  'ngtemplates'
  'concat'
  'ngmin'
  'copy:dist'
  'cdnify'
  'cssmin'
  'uglify'
  'rev'
  'usemin'
]

gulp.task 'default', [
  'newer:jshint'
  'test'
  'build'
]
