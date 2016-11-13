var gulp = require('gulp');
var config = require('../config');

gulp.task('www', function() {
    gulp.src(config.build_source + 'web/.htaccess').pipe(gulp.dest(config.build_dest));
    gulp.src(config.build_source + 'web/*').pipe(gulp.dest(config.build_dest));
});
