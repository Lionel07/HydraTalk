var gulp = require('gulp');
var runSequence = require('run-sequence');
gulp.task('build', function() {
    return runSequence(
        ['html','less','images','debug', 'coffee', 'electron', 'bower']
	);
});
