var gulp = require('gulp');
var webserver = require('gulp-webserver');
 
gulp.task('webserver', function() {
  gulp.src('dist/')
    .pipe(webserver({
      livereload: false,
      open: true,
      https: false
    }));
});
