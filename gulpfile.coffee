gulp = require 'gulp'

$ = require('gulp-load-plugins')
  pattern: ['gulp-*', 'main-bower-files', 'uglify-save-license', 'del', 'merge-stream', 'run-sequence']

handleError =
  $.notify.onError
    title: "Gulp Error: <%= error.plugin %>"
    message: "<%= error.name %>: <%= error.toString() %>"

clientDistFolder = 'dist/public'
serverDistFolder = 'dist/server'

gulp.task 'clean', ->
  $.del ['.tmp', 'dist']

gulp.task 'clean:dev', ->
  $.del ['.tmp']

gulp.task 'copy:index', ->
  gulp.src 'client/index.tmpl.html'
  .pipe $.rename('index.html')
  .pipe gulp.dest('client/')

gulp.task 'copy:constJs', ->
  gulp.src 'server/common/Const.coffee'
  .pipe gulp.dest('client/components/common/')

gulp.task 'copy:dist', ->
  gulp.src [
      'client/*.{ico,png,txt}'
      'client/.htaccess'
      'client/bower_components/**/*'
      'client/assets/images/**/*'
      'client/assets/fonts/**/*'
    ]
  , base: 'client'
  .pipe gulp.dest(clientDistFolder)

  gulp.src ['server/**/*']
  .pipe gulp.dest(serverDistFolder)

  gulp.src ['package.json']
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
    sources = gulp.src([
        "client/{#{appPath},components}/**/*.less",
        "!client/#{appPath}/app.less"
      ], read:false).pipe $.order()

    target
    .pipe($.inject sources,
      transform: (filePath) ->
        filePath = filePath.replace("/client/#{appPath}/", '')
        filePath = filePath.replace('/client/components/', '')
        '@import \'' + filePath + '\';'
      starttag: '// injector:less'
      endtag: '// endinjector'
    )
    .pipe gulp.dest("client/#{appPath}/")

  $.mergeStream [
    doInjectLess 'app'
    doInjectLess 'test'
    doInjectLess 'admin'
  ]

gulp.task 'injector:scripts', ->
  doInjectJs = (appPath, indexPath) ->
    target = gulp.src 'client/' + indexPath + 'index.html'
    sources = gulp.src([
      "{.tmp,client}/{#{appPath},components}/**/*.js"
      "!{.tmp,client}/{#{appPath},components}/{app,components,mock}.js"
      "!{.tmp,client}/{#{appPath},components}/**/*.spec.js"
      ]
    , read:false).pipe $.order()

    target
    .pipe($.inject sources,
      transform: (filePath) ->
        filePath = filePath.replace('/client/', '')
        filePath = filePath.replace('/.tmp/', '')
        '<script src="' + filePath + '"></script>'
      starttag: '<!-- injector:js -->'
      endtag: '<!-- endinjector -->'
    )
    .pipe gulp.dest('client/' + indexPath)

  $.mergeStream [
    doInjectJs 'app'  , ''
    doInjectJs 'test' , 'test/'
    doInjectJs 'admin', 'admin/'
  ]

#injector bower
gulp.task 'bower', ->
  doInjectBower = (indexPath) ->
    target = gulp.src('client/' + indexPath + '/index.html')
    jsSources = gulp.src($.mainBowerFiles(filter:/.js$/), {base:'client/bower_components', read:false})
    cssSources = gulp.src($.mainBowerFiles(filter:/.css$/), {base:'client/bower_components', read:false})

    target
    .pipe($.inject jsSources,
      transform: (filePath) ->
        filePath = filePath.replace('/client/', '')
        filePath = filePath.replace('/.tmp/', '')
        '<script src="' + filePath + '"></script>'
      starttag: '<!-- bower:js -->'
      endtag: '<!-- endbower -->'
    )
    .pipe($.inject cssSources,
      transform: (filePath) ->
        filePath = filePath.replace('/client/', '')
        filePath = filePath.replace('/.tmp/', '')
        '<link rel="stylesheet" href="' + filePath + '">'
      starttag: '<!-- bower:css -->'
      endtag: '<!-- endbower -->'
    )
    .pipe gulp.dest('client/' + indexPath)

  $.mergeStream [
    doInjectBower ''
    doInjectBower 'admin/'
    doInjectBower 'test/'
  ]

gulp.task 'compile', ['coffee:client', 'coffee:server', 'less']

gulp.task 'imagemin', ['imagemin', 'svgmin']

gulp.task 'coffee:client', ->
  clientPaths = 'app,components,admin,test'
  gulp.src [
    "client/{#{clientPaths}}/**/*.coffee",
    "!client/{#{clientPaths}/**/*.spec.coffee"
  ]
  .pipe $.coffee(bare: true).on('error', handleError)
  .pipe gulp.dest('.tmp')

gulp.task 'coffee:server', ->
  gulp.src ['server/{*,*/*,*/*/*}.{coffee,litcoffee,coffee.md}']
  .pipe $.coffee(bare:true).on('error', handleError)
  .pipe gulp.dest('server')

gulp.task 'less', ->
  doLess = (appPath) ->
    paths = ['client/bower_components', "client/#{appPath}", 'client/components']
    gulp.src "client/#{appPath}/app.less"
    .pipe $.less(paths:paths).on('error', handleError)
    .pipe gulp.dest(".tmp/#{appPath}/")

  $.mergeStream [
    doLess 'app'
    doLess 'test'
    doLess 'admin'
  ]

gulp.task 'imagemin', ->
  gulp.src ['client/assets/images/{,*/}*.{png,jpg,jpeg,gif}']
  .pipe $.imagemin()
  .pipe gulp.dest(clientDistFolder + '/assets/images/')

gulp.task 'svgmin', ->
  gulp.src ['client/assets/images/{,*/}*.svg']
  .pipe $.svgmin()
  .pipe gulp.dest(clientDistFolder + '/assets/images/')

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
  $.nodemon { script:'./server/app.js', ext:'js', watch:'server', delay:1.5}
  .on 'restart', ->
    console.log 'restarted!'
  gulp.src "client/index.html"
  .pipe $.wait(1000)
  .pipe $.open('', url:"http://localhost:#{process.env.PORT or 9001}")

gulp.task 'express:prod', ->
  $.express.run
    port: process.env.PORT or 9001
    file: serverDistFolder + '/app.js'

gulp.task 'wait', ->
  $.wait(1000)

gulp.task 'usemin', ->
  doUseMin = (indexPath, outputRelativePath) ->
    gulp.src 'client/' + indexPath + 'index.html'
    .pipe $.usemin( outputRelativePath: outputRelativePath )
    .pipe gulp.dest( clientDistFolder + '/' + indexPath )

  $.mergeStream [
    doUseMin ''      , ''
    doUseMin 'admin/', '../'
    doUseMin 'test/' , '../'
  ]

gulp.task 'ngtemplates', ->
  doNgTemplates = (appPath, indexPath, moduleName) ->
    gulp.src [
      "client/{#{appPath},components}/**/*.html"
      "!client/#{appPath}/index.html"
    ]
    .pipe $.angularTemplatecache(
        module: moduleName
      )
    .pipe gulp.dest('.tmp/' + indexPath)

  $.mergeStream [
    doNgTemplates 'app'  , ''       , 'mauiApp'
    doNgTemplates 'admin', 'admin/' , 'mauidmin'
    doNgTemplates 'test' , 'test/'  , 'mauiTestApp'
  ]

gulp.task 'concat:template', ->
  doConcat = (appPath, indexPath) ->
    sources = gulp.src [
        "#{clientDistFolder}/#{appPath}/app.js"
        ".tmp/#{indexPath}templates.js"
      ]
    sources.pipe $.concat('app.js')
    .pipe gulp.dest("#{clientDistFolder}/#{appPath}/")

  $.mergeStream [
    doConcat 'app'  , ''
    doConcat 'admin', 'admin/'
    doConcat 'test' , 'test/'
  ]

# very slow task
gulp.task 'ngmin', ->
  doNgMin = (appPath) ->
    gulp.src "#{clientDistFolder}/#{appPath}/**/*.js"
    .pipe $.ngAnnotate()
    .pipe gulp.dest("#{clientDistFolder}/#{appPath}/")

  $.mergeStream [
    doNgMin 'app'
    doNgMin 'admin'
    doNgMin 'test'
  ]

gulp.task 'cssmin', ->
  doCssMin = (appPath) ->
    gulp.src "#{clientDistFolder}/#{appPath}/**/*.css"
    .pipe $.cssmin()
    .pipe gulp.dest("#{clientDistFolder}/#{appPath}/")

  $.mergeStream [
    doCssMin 'app'
    doCssMin 'admin'
    doCssMin 'test'
  ]

gulp.task 'uglify', ->
  doUglify = (appPath) ->
    gulp.src "#{clientDistFolder}/#{appPath}/**/*.js"
    .pipe $.uglify()
    .pipe gulp.dest("#{clientDistFolder}/#{appPath}/")

  $.mergeStream [
    doUglify 'app'
    doUglify 'admin'
    doUglify 'test'
  ]

gulp.task 'iconfont', ->
  gulp.src ['client/assets/images/vectors/*.svg']
  .pipe $.iconfont({fontName: 'bud-font', appendCodepoints: true})
  .on('codepoints', (codepoints, options) ->
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
  watchPaths = 'app,components,admin,test'
  gulp.watch [
      "client/{#{watchPaths}}/**/*.coffee"
      "client/{#{watchPaths}}/**/*.spec.coffee"
      "client/{#{watchPaths}}/**/*.mock.coffee"
      "client/{#{watchPaths}}/*.coffee"
    ]
  , ['coffee:client']

  gulp.watch ['server/{*,*/*,*/*/*}.{coffee,litcoffee,coffee.md}']
  , ['coffee:server']

  # 'coffee:client, coffee:server' 这俩 task 有点慢, 所以要等等
  # TODO use as a stream ?
  gulp.watch ['.tmp/**/*.js']
  .on 'change', (file) ->
    gulp.src(file.path)
    .pipe($.wait(2000))
    .pipe($.livereload())

  gulp.watch ['client/bower_components/**/*.less', "client/{#{watchPaths}}/**/*.less"]
  , ['less']

  gulp.watch ['.tmp/**/*.css']
  .on('change', $.livereload.changed)

  gulp.watch [
      "{.tmp,client}/{#{watchPaths}}/**/*.html"
      'client/assets/images/{,*//*}*.{png,jpg,jpeg,gif,webp,svg}'
    ]
  .on('change', $.livereload.changed)

gulp.task 'dist', ->
  $.runSequence(
    'build'
    'env:all'
    'env:prod'
    'express:prod'
  )

gulp.task 'build', ->
  $.runSequence(
    'clean'
    'copy:index'
    'copy:constJs'
    'injector:less'
    'compile'
    'imagemin'
    'injector:scripts'
    'replace'
    'ngtemplates' # may cause error
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
  $.runSequence(
    'clean:dev'
    'env:all'
    'copy:index'
    'copy:constJs'
    'injector:less'
    'compile'
    'injector:scripts'
    'replace'
    'processhtml'
    'bower'
    'autoprefixer'
    'express:dev'
    'watch'
  )

