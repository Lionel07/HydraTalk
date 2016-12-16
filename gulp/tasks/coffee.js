var gulp = require('gulp');
var config = require('../config');
var gutil = require('gulp-util');
var coffee = require('gulp-coffee');
var concat = require('gulp-concat');

gulp.task('coffee', function() {
    return gulp.src(config.coffee.src)
        .pipe(coffee({bare: false}).on('error', swallowError))
        //.pipe(concat(config.coffee.bundle_name))
        .pipe(gulp.dest(config.coffee.dest));
});

function swallowError (error) {
  gutil.log(error.toString())
  this.emit('end')
}
