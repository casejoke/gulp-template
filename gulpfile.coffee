gulp    = require 'gulp'
notify  = require 'gulp-notify'
coffee  = require 'gulp-coffee'
jscs    = require 'gulp-jscs'
uglify  = require 'gulp-uglify'
minify  = require 'gulp-minify-css'
less    = require 'gulp-less'
rename  = require 'gulp-rename'
gutil   = require 'gulp-util'
concat  = require 'gulp-concat'
lib     = do require 'bower-files'


#gulp.task 'jscs', ->
#  gulp.src 'public'
#  .pipe do jscs
version = require('./package.json').version
name    = require('./package.json').name

lessDir = 'src/less'
cssTarget = 'public/css'

jsTarget = 'public/js'

gulp.task 'bower_build',->
  gulp.src lib.ext('js').files
  .pipe concat 'lib.js'
  .pipe gulp.dest jsTarget

gulp.task 'coffee', ->
  gulp.src 'src/coffee/*.coffee'
  .pipe do coffee
  #.pipe do uglify
  .pipe gulp.dest 'public/js'
  .pipe notify 'Coffee compiled'

gulp.task 'css', ->
  gulp.src lessDir + '/application.less'
    .pipe less()
    .on 'error', gutil.log
    .on 'error', notify.onError()
    .pipe rename name+'.'+version+'.css'
    .pipe gulp.dest cssTarget
    .pipe rename name+'.min.css'
    .pipe minify()
    .pipe gulp.dest cssTarget
    .pipe notify 'LESS compiled'

gulp.task 'watch',->
  gulp.watch 'src/coffee/*.coffee',['coffee']
  gulp.watch 'src/less/*.less',['css']

gulp.task 'default',['coffee','css','bower_build']