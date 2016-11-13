var gulp = require('gulp');
var gutil = require('gulp-util');   
var config = require('../config');
var coffee = require('gulp-coffee');
gulp.task('debug', function() {
    return gulp.src(config.debug.src)
        .pipe(coffee({bare: false}).on('error', gutil.log))
        .pipe(gulp.dest(config.debug.dest));
});
