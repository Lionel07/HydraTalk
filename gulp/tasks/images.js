var gulp        = require('gulp');
var config = require('../config');
var changed     = require('gulp-changed');

gulp.task('images', function() {
    return gulp.src(config.images.src)
        .pipe(changed(config.images.dest))
        .pipe(gulp.dest(config.images.dest));
});
