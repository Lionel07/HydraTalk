var gulp = require('gulp');
var config = require('../config');
var changed = require('gulp-changed');

var less = require('gulp-less');
var less_plugin_autoprefix = require('less-plugin-autoprefix');
var autoprefix = new less_plugin_autoprefix({cascade: true});
gulp.task('less', function() {
    gulp.src(config.less.src)
      .pipe(less({
          plugins: [autoprefix],
          compress: true
      }))
      .pipe(gulp.dest(config.less.dest));
});
