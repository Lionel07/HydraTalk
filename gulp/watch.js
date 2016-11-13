'use strict';
var gulp = require('gulp');
var config = require('./config');

gulp.task('watch', function() {
    gulp.watch(config.html.src, ['html']);
    gulp.watch(config.less.allsrc, ['less']);
    gulp.watch(config.coffee.src, ['coffee']);
    gulp.watch(config.electron.src, ['electron']);
    gulp.watch(config.www.src, ['web']);
    gulp.watch(config.images.src, ['images']);
    gulp.watch(config.debug.src, ['debug']);
});
