const gulp = require("gulp");
const yarn = require("gulp-yarn");
const zip = require("gulp-zip");
const fs = require("fs");
const rimraf = require("rimraf");
const runSequence = require("run-sequence");

const project = JSON.parse(fs.readFileSync("./package.json"));

// Clean dist folder
gulp.task("clean", (done) => {
  const options = { glob: false };
  rimraf("stage", options, () => {
    rimraf("dist", options, done);
  });
});

// Install node_modules within build folder
gulp.task("install", () => {
  return gulp
    .src(["package.json", "../yarn.lock"])
    .pipe(gulp.dest("stage/"))
    .pipe(
      yarn({
        production: true
      })
    );
});

// Stage app folder
gulp.task("copySrc", () => {
  return gulp.src(["src/*"], { base: "." }).pipe(gulp.dest("stage/"));
});

// Now the dist directory is ready to go. Zip it.
gulp.task("bundle", () => {
  return gulp
    .src(["stage/**/*", "!stage/package.json", "!stage/yarn.lock", "stage/.*"])
    .pipe(zip(`${project.name}-${project.version}.zip`))
    .pipe(gulp.dest("dist"));
});

// Do everything
gulp.task("default", (done) => {
  return runSequence(["clean"], ["copySrc"], ["install"], ["bundle"], done);
});
