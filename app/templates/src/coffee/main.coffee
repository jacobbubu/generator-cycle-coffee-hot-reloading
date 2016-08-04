{run}        = require '@cycle/core'
{Observable} = require 'rx'
{makeDOMDriver, div, span, img}  = require '@cycle/dom'

drivers =
    DOM: makeDOMDriver '#container'

app = ({DOM}) ->
    DOM: Observable.just div '.hello-world', [
        span 'Change me in "src/coffee/main.coffee"'
        img
            attrs:
                src: 'http://localhost:3000/images/coffeeCup.svg'
                style: "width: 1em; height: 1em; padding-left: 0.2em"
    ]

run app, drivers

if module.hot
    module.hot.accept()
