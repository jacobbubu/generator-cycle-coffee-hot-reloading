module.exports =
    scripts:
        source: './src/coffee/main.coffee'
        extensions: ['.coffee']
        transforms: ['coffee-reactify', 'envify']
        destination: './dist/js/'
        filename: 'bundle.js'
    templates:
        source: './src/jade/*.jade'
        watch: './src/jade/*.jade'
        destination: './dist/'
    styles:
        source: './src/stylus/style.styl'
        watch: './src/stylus/*.styl'
        destination: './dist/css/'
    assets:
        source: [
            './src/favicon.ico'
            './src/apple-touch-icon.png'
            './src/humans.txt'
            './src/robots.txt'
            './src/assets/**/*.*'
        ]
        watch: [
            './src/favicon.ico'
            './src/apple-touch-icon.png'
            './src/humans.txt'
            './src/robots.txt'
            './src/assets/**/*.*'
        ]
        destination: './dist/'