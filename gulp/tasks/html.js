var gulp = require('gulp');
var config = require('../config');
var changed = require('gulp-changed');

gulp.task('html', function() {
    return gulp.src(config.html.src)
        .pipe(changed(config.html.dest))
        .pipe(gulp.dest(config.html.dest));
});
