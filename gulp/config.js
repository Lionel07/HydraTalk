"use strict";

var base = "src/";
var dest = "dist/";

module.exports = {
    build_dest: dest,
    build_source: base,
    html: {
        src:  base + "html/*.html",
        dest: dest
    },
    debug: {
        src:  base + "debug/*.coffee",
        dest: dest + "debug/"
    },
    coffee: {
        src:  base + "coffee/**/*.coffee",
        dest: dest + "js/",
        bundle_name: "app.js"
    },
    less: {
        src:  base + "less/main.less",
        allsrc:  base + "less/*.less",
        dest: dest + "css/"
    },
    libs: {
        dest: dest + "bower/"
    },
    electron: {
        src:  base + "electron/*",
        dest: dest + "electron/"
    },
    www: {
        src:  base + "www/*.*",
        dest: dest + "www/"
    },
    images: {
        src:  base + "images/**/*.*",
        dest: dest + "images/"
    }
};
