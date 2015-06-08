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
removeLogs = require 'gulp-removelogs';
#lib     = do require 'bower-files'
spritesmith  = require 'gulp.spritesmith'


version = require('./package.json').version
name    = require('./package.json').name

lessDir = 'src/less'
cssTarget = '../admin/view/public/css'
imagesTarget = '../admin/view/public/css/img'

jsTarget = '../admin/view/public/js'

fontsTarget = '../admin/view/public/fonts'

# Copy vendor JS files, concatenate them and uglify them
gulp.task 'js', ->
  gulp.src [
    'bower_components/modernizr/modernizr.js',
    'bower_components/jquery/dist/jquery.js',
    'bower_components/bootstrap/js/transition.js',
    'bower_components/bootstrap/js/alert.js',
    'bower_components/bootstrap/js/button.js',
    'bower_components/bootstrap/js/carousel.js',
    'bower_components/bootstrap/js/collapse.js',
    'bower_components/bootstrap/js/dropdown.js',
    'bower_components/bootstrap/js/modal.js',
    'bower_components/bootstrap/js/tooltip.js',
    'bower_components/bootstrap/js/popover.js',
    'bower_components/bootstrap/js/scrollspy.js',
    'bower_components/bootstrap/js/tab.js',
    'bower_components/bootstrap/js/affix.js',
    #'bower_components/OwlCarousel/owl-carousel/owl.carousel.js',
    #'bower_components/magnific-popup/dist/jquery.magnific-popup.js',
    #'bower_components/shufflejs/dist/jquery.shufflejs.js',
    #'bower_components/wowjs/dist/wow.js',
    #'bower_components/isotope/dist/isotope.pkgd.js',
    #'bower_components/imagesloaded/imagesloaded.js',
    #'src/js/jquery.ajax-progress.js',
    #'src/js/jquery.fitvids.js',
    #'src/js/jquery.parallax-1.1.3.js',
    #'src/js/jquery.sticky.js',
    #'src/js/_contact.js',
    #'src/js/main-init.js'
    ]
    .pipe concat name+'.js'
    .pipe gulp.dest jsTarget
    .pipe do removeLogs
    .pipe rename name+'.min.js'
    .pipe do uglify
    .pipe gulp.dest jsTarget


gulp.task 'coffee', ->
  gulp.src 'src/coffee/*.coffee'
  .pipe do coffee
  #.pipe do uglify
  .pipe gulp.dest jsTarget
  .pipe notify 'Coffee compiled'


gulp.task 'copy_fontawesome', ->
   gulp.src 'bower_components/fontawesome/fonts/*.*'
   .pipe gulp.dest fontsTarget
   .pipe notify 'Copy fontawesome compiled'

#gulp.task 'copy_opensans', ->
#  gulp.src 'bower_components/open-sans-fontface/fonts/**'
#  .pipe gulp.dest 'public/fonts/open-sans/'
#  .pipe notify 'Copy opensans compiled'

gulp.task 'spritesmith', ->
  spriteData = gulp.src 'src/images/*.png', read: false
    .pipe spritesmith 
      imgName: 'sprite.png'
      cssName: '_sprite.less'
      imgPath: 'img/sprite.png'
      cssFormat: 'less'
      algorithm: 'binary-tree'
      padding: 8
      imgOpts:
        format: 'png'

  spriteData.img.pipe gulp.dest imagesTarget
  spriteData.css.pipe gulp.dest lessDir

  return spriteData

gulp.task 'css', ->
  gulp.src lessDir + '/app.less'
    .pipe do less
    .on 'error', gutil.log
    .on 'error', notify.onError()
    .pipe rename name+'.css'
    .pipe gulp.dest cssTarget
    .pipe rename name+'.min.css'
    .pipe minify()
    .pipe gulp.dest cssTarget
    .pipe notify 'LESS compiled'

gulp.task 'watch',->
  gulp.watch 'src/coffee/*.coffee',['coffee']
  gulp.watch 'src/less/*.less',['css']
  gulp.watch 'src/js/*.js',['js']
  gulp.watch 'src/images/*.png',['spritesmith']

gulp.task 'default',[
  'coffee',
  'spritesmith',
  'css',
  'js'
  'copy_fontawesome'
  ]








