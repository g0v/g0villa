require! <[ gulp gulp-util gulp-less gulp-jade gulp-insert gulp-concat streamqueue]>

build-path = '_public'

gulp.task \less ->
  gulp.src \assets/css/*.less
    .pipe gulp-less!
    .pipe gulp.dest "#build-path"

gulp.task \js ->
  template = gulp.src \assets/*.jade
    .pipe gulp-jade!
    .pipe gulp-insert.prepend 'TabzillaContent = \''
    .pipe gulp-insert.append '\';'
  streamqueue { +objectMode }
    .done template, gulp.src \assets/js/*.js
    .pipe gulp-concat 'tabzilla.js'
    .pipe gulp.dest "#build-path"

gulp.task 'img' ->
  gulp.src 'assets/images/**'
    .pipe gulp.dest '_public/images'

gulp.task \express, ->
  require! express
  app = express!
  EXPRESSPORT = 3000
  app.use express.static "#build-path"
  app.listen EXPRESSPORT
  gulp-util.log "Server available at http://localhost:#EXPRESSPORT"

gulp.task \build <[ less js img ]>
gulp.task \default <[ build express ]>
