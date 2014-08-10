var 
gulp       = require('gulp'),
purescript = require('gulp-purescript'),
runSq      = require('run-sequence'),
karma      = require('gulp-karma'),
gulpif     = require('gulp-if'),
concat     = require('gulp-concat'),

src        = ['bower_components/purescript-*/src/**/*.purs',
              'bower_components/chai/chai.js',
              'src/Control/Reactive/Event.purs',
              'tests/Control/Reactive/Event.Spec.purs',
              'tests/Main.purs'],
dest       = {
              path : 'tmp/',
              file : 'Test.js'
            },
psc        = purescript.psc({
              main        : true,
              output      : dest.file
            }),
karma      = karma({              
              configFile  : "./tests/karma.conf.js",
              action      : "run"
            });

gulp.task('build:test', function(){
  gulp.src(src)
    .pipe(gulpif(/purs/, psc))
    .pipe(concat(dest.file))
    .pipe(gulp.dest(dest.path));
});

gulp.task('docgen', function(){
  gulp.src("src/**/*.purs")
    .pipe(purescript.docgen())
    .pipe(gulp.dest("README.md"));
});

gulp.task('test:unit',function(){
  gulp.src(dest.path+dest.file).pipe(karma);
});

gulp.task('test', function(){ runSq('build:test', 'test:unit'); });