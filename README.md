# generator-cycle-coffee-hot-reloading

Generate a boilerplate project using cycle.js, coffee-script and with hot reloading support(only for coffee-script).

Jade and stylus code changes will cause a live-reloading.

## Getting Started

Not every new computer comes with a Yeoman pre-installed. You only have to install it once.

```bash
$ npm install -g yo
```

### Yeoman Generators

To install generator-gulp-coffee-react from npm, run:

```bash
$ npm install -g generator-cycle-coffee-hot-reloading
```

And then, create a directory to put you framer project in:

```bash
$ mkdir your-proj && cd $_
```

After that, initiate the generator:

```bash
$ yo cycle-coffee-hot-reloading
```

This step takes time to install all dependencies that your project needs.

Finally, run `npm start` to start your development server and see the demo project.

I'm using [browserify](https://github.com/substack/node-browserify) for code bundling, [browserify-hmr](https://github.com/AgentME/browserify-hmr) for hot reloading and [browser-sync](https://www.browsersync.io) for the development web server.

[browserify-hmr](https://github.com/AgentME/browserify-hmr) will also start a websocket server on port 3123 for the browser checking whether the coffee-script code changes.