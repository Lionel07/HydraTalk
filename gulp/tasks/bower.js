'use strict';
var gulp = require('gulp');
var config = require('../config');
var bower = require('main-bower-files');
var bowerNormalizer = require('gulp-bower-normalize');
gulp.task('bower', function() {
    return gulp.src(bower(), {base: './bower_components'})
        .pipe(bowerNormalizer({bowerJson: './bower.json', flatten: true}))
        .pipe(gulp.dest(config.libs.dest))
});
