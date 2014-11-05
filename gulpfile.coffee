gulp = require 'gulp'
del = require 'del'
runSequence = require 'run-sequence'
merge = require 'merge-stream'

$ = require('gulp-load-plugins')
  pattern: ['gulp-*', 'main-bower-files', 'uglify-save-license']

gulp.task 'clean', ()->
  del ['.tmp', 'dist']

gulp.task 'clean:dev', ()->
  del ['.tmp']

gulp.task 'copy:index', ->
  gulp.src 'client/index.tmpl.html'
  .pipe $.rename('index.html')
  .pipe gulp.dest('client/')

gulp.task 'copy:dist', ->
  gulp.src [
      'client/*.{ico,png,txt}'
      'client/.htaccess'
      'client/bower_components/**/*'
      'client/assets/images/**/*'
      'client/assets/fonts/**/*'
    ]
  , base: 'client'
  .pipe gulp.dest('dist/public')

  gulp.src [
      'server/**/*'
    ]
  .pipe gulp.dest('dist/server')

  gulp.src [
      'package.json'
    ]
  .pipe gulp.dest('dist')

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
  doInjectLess = (appPath) ->
    target = gulp.src "client/#{appPath}/app.less"
    sources = gulp.src ["client/{#{appPath},components}/**/*.less","!client/#{appPath}/app.less"], {read: false}
                  .pipe $.order()
    target.pipe($.inject sources,
      transform: (filePath) ->
        filePath = filePath.replace("/client/#{appPath}/", '')
        filePath = filePath.replace('/client/components/', '')
        '@import \'' + filePath + '\';'
      starttag: '// injector:less'
      endtag: '// endinjector'
    )
    .pipe gulp.dest("client/#{appPath}/")

  merge [
    doInjectLess('app')
    doInjectLess('test')
  ]

gulp.task 'injector:scripts', ->
  doInjectJs = (appPath, indexPath) ->
    target = gulp.src indexPath + 'index.html'
    sources = gulp.src [
      "{.tmp,client}/{#{appPath},components}/**/*.js",
      "!{.tmp,client}/#{appPath}/app.js",
      "!{.tmp,client}/{#{appPath},components}/**/*.spec.js",
      "!{.tmp,client}/{#{appPath},components}/**/*.mock.js"
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
    .pipe gulp.dest(indexPath)

  merge [
    doInjectJs('app', 'client/')
    doInjectJs('test', 'client/test/')
  ]

#injector bower
gulp.task 'bower', ->
  doInjectBower = (appPath, indexPath) ->
    bowerFiles = require('main-bower-files')
    gulp.src indexPath + '/index.html'
    .pipe $.inject(gulp.src(bowerFiles(filter: /.js$/), { base: 'client/bower_components',read: false}),
      transform: (filePath) ->
        filePath = filePath.replace('/client/', '')
        filePath = filePath.replace('/.tmp/', '')
        '<script src="' + filePath + '"></script>'
      starttag: '<!-- bower:js -->'
      endtag: '<!-- endbower -->'
    )
    .pipe $.inject(gulp.src(bowerFiles(filter: /.css$/), { base: 'client/bower_components',read: false}),
      transform: (filePath) ->
        filePath = filePath.replace('/client/', '')
        filePath = filePath.replace('/.tmp/', '')
        '<link rel="stylesheet" href="' + filePath + '">'
      starttag: '<!-- bower:css -->'
      endtag: '<!-- endbower -->'
    )
    .pipe gulp.dest(indexPath)

  merge [
    doInjectBower('app', 'client/')
    doInjectBower('test', 'client/test/')
  ]


gulp.task 'injector', ['injector:less','injector:scripts']

gulp.task 'concurrent:server', ['coffee:client', 'coffee:server', 'less']

gulp.task 'concurrent:dist', ['coffee:clientDist','coffee:server', 'less', 'imagemin', 'svgmin']

gulp.task 'concurrent:test', ['coffee','less']

gulp.task 'coffee', ['coffee:client', 'coffee:clientDist', 'coffee:server']

gulp.task 'coffee:client', ->
  gulp.src ['client/{app,components,test}/**/*.coffee', '!client/{app,components}/**/*.spec.coffee']
  .pipe($.coffee({bare: true}))
  .pipe(gulp.dest('.tmp'))

gulp.task 'coffee:clientDist', ->
  gulp.src ['client/{app,components}/**/*.coffee'
            '!client/{app,components}/**/*.spec.coffee'
            '!client/{app,components}/**/*.mock.coffee'
            '!client/app/mock.coffee'
          ]
  .pipe($.coffee({bare: true}))
  .pipe(gulp.dest('.tmp'))

gulp.task 'coffee:server', ->
  gulp.src ['server/{*,*/*,*/*/*}.{coffee,litcoffee,coffee.md}']
  .pipe($.coffee({bare: true}))
  .pipe(gulp.dest('server'))

gulp.task 'less', ->
  doLess = (appPath) ->
    gulp.src "client/#{appPath}/app.less"
    .pipe $.less(paths:['client/bower_components', "client/#{appPath}", 'client/components'])
    .pipe gulp.dest(".tmp/#{appPath}/")

  merge [
    doLess('app')
    doLess('test')
  ]

gulp.task 'imagemin', ->
  gulp.src ['client/assets/images/{,*/}*.{png,jpg,jpeg,gif}']
  .pipe $.imagemin()
  .pipe gulp.dest('dist/public/assets/images/')

gulp.task 'svgmin', ->
  gulp.src ['client/assets/images/{,*/}*.svg']
  .pipe $.svgmin()
  .pipe gulp.dest('dist/public/assets/images/')

gulp.task 'replace', ->
  gulp.src(['client/index.html'])
  .pipe($.replace(/mauiAppDev/g, 'mauiApp'))
  .pipe(gulp.dest('client/'))

# what does this do?
gulp.task 'processhtml', ->
  gulp.src('client/index.html')
  .pipe($.processhtml())
  .pipe(gulp.dest('client/'))

# Changes the CSS indentation to create a nice visual cascade of prefixes.
gulp.task 'autoprefixer', ->
  gulp.src ['.tmp/{,*/}*.css']
  .pipe $.autoprefixer(
      browsers: ['last 2 versions']
      cascade: false
    )
  .pipe gulp.dest('.tmp/')

gulp.task 'express:dev', ->
  $.nodemon { script: './server/app.js',ext: 'js', watch: 'server', delay: 1.5}
  .on 'restart', ()->
    console.log 'restarted!'
  gulp.src "client/index.html"
  .pipe $.wait(1000)
  .pipe $.open('', url: "http://localhost:#{process.env.PORT or 9000}")

gulp.task 'express:prod', ->
  $.express.run
    port: process.env.PORT or 9000
    file: 'dist/server/app.js'

gulp.task 'wait', ->
  $.wait(1000)

# should point to a file src :(
gulp.task 'open', ->
  gulp.src "client/index.html"
  .pipe $.open('', url: "http://localhost:#{process.env.PORT or 9000}")

gulp.task 'usemin', ->
  gulp.src 'client/index.html'
  .pipe $.usemin()
  .pipe(gulp.dest('dist/public'))

gulp.task 'ngtemplates', ->
  gulp.src 'client/{app,components}/**/*.html'
  .pipe $.angularTemplatecache(
      module: 'mauiApp'
    )
  .pipe gulp.dest('.tmp/')

gulp.task 'concat:template', ->
  sources = gulp.src [
      'dist/public/app/app.js'
      '.tmp/templates.js'
    ]
  sources.pipe $.concat('app.js')
  .pipe gulp.dest('dist/public/app/')

# very slow task
gulp.task 'ngmin', ->
  gulp.src 'dist/public/app/**/*.js'
  .pipe $.ngAnnotate()
  .pipe gulp.dest('dist/public/app/')

gulp.task 'cssmin', ->
  gulp.src 'dist/public/app/**/*.css'
  .pipe $.cssmin()
  .pipe gulp.dest('dist/public/app/')

gulp.task 'uglify', ->
  gulp.src 'dist/public/app/**/*.js'
  .pipe $.uglify()
  .pipe gulp.dest('dist/public/app/')

gulp.task 'rev', ->
  sources = gulp.src [
      'dist/public/{,*/}*.js'
      'dist/public/{,*/}*.css'
      'dist/public/assets/images/**/*'
      'dist/public/assets/fonts/**/*'
    ]
  , base: 'dist/public'

  sources.pipe($.rev())
  .pipe(gulp.dest('dist/public/'))

gulp.task 'iconfont', ->
  gulp.src ['client/assets/images/vectors/*.svg']
  .pipe($.iconfont({fontName: 'bud-font', appendCodepoints: true}))
  .on('codepoints', (codepoints, options)->
    gulp.src('client/assets/fonts/font-template.less')
    .pipe($.consolidate('lodash',
        glyphs: codepoints,
        fontName: 'bud-font' # required
        fontPath: '../../assets/fonts/bud-font/'
        className: 'budon'
      )
    )
    .pipe(gulp.dest('client/app/theme/'))
  )
  .pipe(gulp.dest('client/assets/fonts/bud-font'))

gulp.task 'watch', ->
  $.livereload.listen()
  $.wait(1000)
  gulp.watch [
      'client/{app,components,test}/**/*.coffee'
      'client/{app,components,test}/**/*.spec.coffee'
      'client/{app,components,test}/**/*.mock.coffee'
      'client/app/mock.coffee'
    ]
  , ['coffee:client']
  gulp.watch ['server/{*,*/*,*/*/*}.{coffee,litcoffee,coffee.md}']
  , ['coffee:server']

  gulp.watch ['.tmp/**/*.js']
  .on('change', $.livereload.changed)

  gulp.watch ['client/bower_components/**/*.less', 'client/{app,components,test}/**/*.less']
  , ['less']

  gulp.watch ['.tmp/**/*.css']
  .on('change', $.livereload.changed)

  gulp.watch [
      '{.tmp,client}/{app,components,test}/**/*.html',
      'client/assets/images/{,*//*}*.{png,jpg,jpeg,gif,webp,svg}'
    ]
  .on('change', $.livereload.changed)

gulp.task 'dist', ->
  runSequence(
    'build'
    'env:all'
    'env:prod'
    'express:prod'
  )

gulp.task 'build', ->
  runSequence(
    'clean'
    'admin'
    'copy:index'
    'injector:less'
    'concurrent:dist'
    'ngtemplates' # may cause error
    'injector:scripts'
    'replace'
    'processhtml'
    'bower'
    'autoprefixer'
    'usemin'
    'concat:template'
    'ngmin' # may cause error
    'copy:dist'
    'cssmin' # may cause error
    'uglify'
  )

gulp.task 'dev', ->
  runSequence(
    'clean:dev'
    'copy:index'
    'env:all'
    'injector:less'
    'concurrent:server'
    'admin'
    'injector:scripts'
    'replace'
    'processhtml'
    'bower'
    'autoprefixer'
    'express:dev'
    'watch'
    'watch:admin'
  )

# admin
gulp.task 'injector:admin', ->
  lessSources = gulp.src ['client/{admin,components}/**/*.less','!client/admin/app.less'], {read: false}
            .pipe $.order()
  gulp.src 'client/admin/app.less'
  .pipe($.inject lessSources,
    transform: (filePath) ->
      filePath = filePath.replace('/client/admin/', '')
      filePath = filePath.replace('/client/components/', '')
      '@import \'' + filePath + '\';'
    starttag: '// injector:less'
    endtag: '// endinjector'
  )
  .pipe(gulp.dest('client/admin/'))

  gulp.src 'client/admin/index.html'
  .pipe($.inject (gulp.src '.tmp/{admin,components}/**/*.js', {read: false}),
    transform: (filePath) ->
      filePath = filePath.replace('/client/', '')
      filePath = filePath.replace('/.tmp/', '')
      '<script src="' + filePath + '"></script>'
    starttag: '<!-- injector:js -->'
    endtag: '<!-- endinjector -->'
  )
  .pipe(gulp.dest('client/admin'))

gulp.task 'coffee:admin', ->
  gulp.src ['client/admin/**/*.coffee'], base: 'client/admin'
  .pipe($.coffee({bare: true}))
  .pipe(gulp.dest('.tmp/admin'))

gulp.task 'less:admin', ->
  gulp.src('client/admin/app.less')
  .pipe $.less({paths: ['client/bower_components', 'client/admin', 'client/components']})
  .pipe(gulp.dest('.tmp/admin/'))

gulp.task 'watch:admin', ->
  gulp.watch [
      'client/admin/**/*.coffee'
      'client/admin/**/*.spec.coffee'
      'client/admin/**/*.mock.coffee'
      'client/admin/mock.coffee'
    ]
  , ['coffee:admin']

  gulp.watch ['client/bower_components/**/*.less', 'client/{admin,components}/**/*.less']
  , ['less:admin']

  gulp.watch [
      '{.tmp,client}/admin/**/*.html',
    ]
  .on('change', $.livereload.changed)

gulp.task 'admin', ->
  runSequence 'coffee:admin', 'injector:admin', 'less:admin', ->
    gulp.src 'client/admin/index.html'
    .pipe(gulp.dest('.tmp/admin'))
    .pipe $.usemin()
    .pipe(gulp.dest('dist/public/admin'))

# end of admin
