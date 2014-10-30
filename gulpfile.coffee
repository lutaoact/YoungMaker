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
  gulp.src 'client/index.tmpl.html'
  .pipe $.copy('client/index.html')

gulp.task 'copy:dist', ->
  gulp.src [
    'client/*.{ico,png,txt}'
    'client/.htaccess'
    'client/bower_components/**/*'
    'client/assets/images/{*/}*.{webp}'
    'client/assets/fonts/**/*'
    'client/index.html'
  ]
  .pipe $.copy('dist/public')

gulp.task 'copy:styles', ->
  gulp.src ['client/{app,components}/**/*.css']
  .pipe $.copy('.tmp/')

gulp.task 'env:all', ->
  $.env
    vars: require('./server/config/local.env')

gulp.task 'env:prod', ->
  $.env
    vars:
      NODE_ENV: 'production'

gulp.task 'env:test', ->
  $.env
    vars:
      NODE_ENV: 'test'

gulp.task 'injector:less', ->
  target = gulp.src 'client/app/app.less'
  sources = gulp.src ['client/{app,components}/**/*.less','!client/app/app.less'], {read: false}
  target.pipe($.inject sources,
    transform: (filePath) ->
      filePath = filePath.replace('/client/app/', '')
      filePath = filePath.replace('/client/components/', '')
      '@import \'' + filePath + '\';'
    starttag: '// injector'
    endtag: '// endinjector'
  )
  .pipe(gulp.dest('client/app/'))

gulp.task 'injector:scripts', ->
  target = gulp.src 'client/index.html'
  sources = gulp.src [
    '{.tmp,client}/{app,components}/**/*.js',
    '!{.tmp,client}/app/app.js',
    '!{.tmp,client}/{app,components}/**/*.spec.js',
    '!{.tmp,client}/{app,components}/**/*.mock.js'
    ]
  , {read: false}
  target.pipe($.inject sources,
    transform: (filePath) ->
      filePath = filePath.replace('/client/', '')
      filePath = filePath.replace('/.tmp/', '')
      '<script src="' + filePath + '"></script>'
    starttag: '<!-- injector:js -->'
    endtag: '<!-- endinjector -->'
  )
  .pipe(gulp.dest('client/'))

gulp.task 'injector:css', ->
  target = gulp.src 'client/index.html'
  sources = gulp.src ['client/{app,components}/**/*.less','!client/app/app.less'], {read: false}
  target.pipe($.inject sources,
    transform: (filePath) ->
      filePath = filePath.replace('/client/', '')
      filePath = filePath.replace('/.tmp/', '')
      '<link rel="stylesheet" href="' + filePath + '">'
    starttag: '<!-- injector:css -->'
    endtag: '<!-- endinjector -->'
  )
  .pipe(gulp.dest('client/{app,components}/**/*.css'))

gulp.task 'injector', ['injector:less','injector:scripts','injector:css']

gulp.task 'concurrent:server', ['coffee','less']

gulp.task 'concurrent:dist', ['coffee:clientDist','coffee:server','less','imagemin','svgmin']

gulp.task 'concurrent:test', ['coffee','less']

gulp.task 'coffee', ['coffee:client', 'coffee:clientDist', 'coffee:server']

gulp.task 'coffee:client', ->
  gulp.src ['client/{app,components}/**/*.coffee', '!client/{app,components}/**/*.spec.coffee']
  .pipe($.coffee({bare: true}))
  .pipe(gulp.dest('.tmp'))

gulp.task 'coffee:clientDist', ->
  gulp.src ['client/{app,components}/**/*.coffee'
            'client/!{app,components}/**/*.spec.coffee'
            'client/!{app,components}/**/*.mock.coffee'
            'client/!app/mock.coffee'
          ]
  .pipe($.coffee({bare: true}))
  .pipe(gulp.dest('.tmp'))

gulp.task 'coffee:server', ->
  gulp.src ['server/{*,*/*,*/*/*}.{coffee,litcoffee,coffee.md}']
  .pipe($.coffee({bare: true}))
  .pipe(gulp.dest('server'))

gulp.task 'less', ->
  gulp.src('client/app/app.less')
  .pipe $.less({paths: ['client/bower_components', 'client/app', 'client/components']})
  .pipe(gulp.dest('.tmp/app/'))

gulp.task 'imagemin', ->
  gulp.src ['client/assets/images/{,*/}*.{png,jpg,jpeg,gif}']
  .pipe $.imagemin()
  .pipe gulp.dest('dist/public/assets/images/')

gulp.task 'svgmin', ->
  gulp.src ['client/assets/images/{,*/}*.svg']
  .pipe $.svgmin()
  .pipe gulp.dest('dist/public/assets/images/')

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
