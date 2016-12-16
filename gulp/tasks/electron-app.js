'use strict';

var gulp = require('gulp');
var electron = require('electron-connect').server.create();

gulp.task('electron-app', function () {

  // Start browser process
  electron.start();

  // Restart browser process
  gulp.watch('src/electron/electron-main.js', electron.restart);

  // Reload renderer process
  gulp.watch(['dist/*', 'dist/**/*'], electron.reload);
});
