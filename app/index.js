var yeomanBase = require('yeoman-generator').Base;

var ProjectGenerator = yeomanBase.extend({
    constructor: function() {
        yeomanBase.apply(this, arguments);
    },
    writing: {
        packagejson: function() {
            var pkg = {
                'version': '0.1.0',
                'dependencies': {},
                'scripts': {
                    "start": "NODE_ENV=development gulp --hot",
                    "dev": "NODE_ENV=development gulp build",
                    "prod": "NODE_ENV=production gulp build",
                    "test": "echo \"Error: no test specified\" && exit 1"
                }
            };
            this.write('package.json', JSON.stringify(pkg));
        },
        gulpfile: function() {
            this.log.writeln('Copying gulpfile');
            this.fs.copy(
                this.templatePath('*.coffee'),
                this.destinationPath()
            )},
        otherFiles: function() {
            this.log.writeln('Copying project files');
            this.fs.copy(
                this.templatePath('src/**/*.*'),
                this.destinationPath('src')
            );
            // Copy all dotfiles
            this.copy('.gitignore', '.gitignore');
            this.copy('.npmignore', '.npmignore');
        }
    },
    install: function() {
        var done = this.async();
        this.log.writeln('npm installing');
        this.spawnCommand('npm', [
            'install',
            'gulp',
            'gulp-util',
            'gulp-coffee',
            'gulp-uglify',
            'gulp-jade',
            'gulp-stylus',
            'gulp-cssnano',
            'gulp-filter',
            'gulp-autoprefixer',
            'gulp-notify',
            'gulp-size',
            'gulp-sourcemaps',
            'vinyl-buffer',
            'vinyl-source-stream',
            'browser-sync',
            'browserify',
            'coffee-script',
            'coffee-reactify',
            'pretty-hrtime',
            'chalk',
            'watchify',
            'envify',
            'browserify-hmr',
            'minimist',
            '@cycle/core',
            '@cycle/dom',
            'rx',
            'xstream',
            '--save-dev'
        ])
        .on('exit', function() {
            done();
        }.bind(this));
    },
    end: function() {
        this.log.writeln('All set, run `npm start` to start dev server');
    }
});

module.exports = ProjectGenerator;