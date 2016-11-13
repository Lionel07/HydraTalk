var gulp = require('gulp');
var config = require('../config');
gulp.task('electron', function() {
    gulp.src(config.build_source + 'electron/*').pipe(gulp.dest(config.build_dest + 'electron/'));
});
