browserify          = require 'browserify'
browserSync         = require('browser-sync').create()
chalk               = require 'chalk'
CSSmin              = require 'gulp-cssnano'
filter              = require 'gulp-filter'
gulp                = require 'gulp'
gutil               = require 'gulp-util'
jade                = require 'gulp-jade'
path                = require 'path'
prefix              = require 'gulp-autoprefixer'
prettyTime          = require 'pretty-hrtime'
source              = require 'vinyl-source-stream'
sourcemaps          = require 'gulp-sourcemaps'
stylus              = require 'gulp-stylus'
uglify              = require 'gulp-uglify'
watchify            = require 'watchify'
buffer              = require 'vinyl-buffer'
size                = require 'gulp-size'
notify              = require 'gulp-notify'
hotModuleReloading  = require 'browserify-hmr'
minimist            = require 'minimist'
config              = require './config'

process.env.NODE_ENV ?= 'development'
production   = process.env.NODE_ENV is 'production'
hotReload    = !!minimist(process.argv[2..])['hot']

distFolder = './dist'

handleError = (err) ->
    gutil.log err
    gutil.beep()
    @emit 'end'

buildScripts = (scriptConfig) ->
    bundle = browserify
        entries: [scriptConfig.source]
        extensions: scriptConfig.extensions
        debug: not production
        plugin: if hotReload then hotModuleReloading else []

    scriptConfig.transforms.forEach (t) -> bundle.transform t

    build = bundle.bundle()
        .on 'error', handleError
        # convert node stream to vinyl stream
        .pipe source scriptConfig.filename
        # convert vinyl file in stream to buffer that works more perfomant
        # (read through each file only once) for small files.
        .pipe buffer()
        .pipe sourcemaps.init loadMaps: true

    if production
        build = build.pipe uglify()
        # print out size of the bundle file.
        build.pipe size showFiles: true, gzip: true

    build
        .pipe sourcemaps.write '.'
        .pipe gulp.dest scriptConfig.destination

watchScripts = (scriptConfig) ->
    bundle = watchify browserify
        entries: [scriptConfig.source]
        extensions: scriptConfig.extensions
        debug: not production
        plugin: if hotReload then hotModuleReloading else []
        cache: {}
        packageCache: {}
        fullPaths: true

    scriptConfig.transforms.forEach (t) -> bundle.transform t

    bundle.on 'update', ->
        gutil.log "Starting '#{chalk.cyan 'rebundle'}'..."
        start = process.hrtime()
        build = bundle.bundle()
            .on 'error', handleError
            .pipe source scriptConfig.filename
            .pipe buffer()
            .pipe sourcemaps.init loadMaps: true

        if production
            build = build.pipe uglify()
            build.pipe size showFiles: true, gzip: true

        build
            .pipe sourcemaps.write '.'
            .pipe gulp.dest scriptConfig.destination
            .on 'finish', ->
                gutil.log "Finished '#{chalk.cyan 'rebundle'}' after #{chalk.magenta prettyTime process.hrtime start}"
                bundle.emit 'finish'
    .emit 'update'

    bundle

gulp.task 'scripts', ->
    buildScripts config.scripts

gulp.task 'templates', ->
    pipeline = gulp
        .src config.templates.source
        .pipe jade
            pretty: not production

        .on 'error', handleError
        .pipe gulp.dest config.templates.destination

    pipeline = pipeline.pipe browserSync.reload(stream: true) unless production
    pipeline

gulp.task 'styles', ->
    styles = gulp.src config.styles.source
    styles = styles.pipe sourcemaps.init() unless production
    styles = styles.pipe stylus
            'include css': true

        .on 'error', handleError
        .pipe prefix 'last 2 versions', 'Chrome 34', 'Firefox 28', 'iOS 7'

    styles = styles.pipe CSSmin() if production
    styles = styles.pipe sourcemaps.write '.' unless production
    styles = styles.pipe gulp.dest config.styles.destination

    unless production
        styles = styles
            .pipe filter '**/*.css'
            .pipe browserSync.reload stream: true

    styles

gulp.task 'assets', ->
    gulp
        .src config.assets.source
        .pipe gulp.dest config.assets.destination

gulp.task 'watch', ->
    firstCompile = true
    browserSync.init
        server:
            baseDir: distFolder
        injectChanges: false
        notify: false

    gulp.watch config.templates.watch, ['templates']
        .on 'change', browserSync.reload
    gulp.watch config.styles.watch, ['styles']
        .on 'change', browserSync.reload
    gulp.watch config.assets.watch, ['assets']
        .on 'change', browserSync.reload

    watchScripts(config.scripts).on 'finish', ->
        if firstCompile
            firstCompile = false
            browserSync.reload()

gulp.task 'no-js', ['templates', 'styles', 'assets']
gulp.task 'build', ['scripts', 'no-js']

gulp.task 'default', ['no-js'], -> gulp.start 'watch'