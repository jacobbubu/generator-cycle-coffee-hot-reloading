{run}        = require '@cycle/core'
{Observable} = require 'rx'
{makeDOMDriver, div, span, img}  = require '@cycle/dom'

drivers =
    DOM: makeDOMDriver '#container'

app = ({DOM}) ->
    DOM: Observable.just div '.hello-world', [
        span 'Change me here!'
        img
            src: 'images/coffeeCup.svg'
            style:
                width: '1rem'
                height: '1rem'
    ]

{sinks, sources} = run app, drivers

if module.hot
    module.hot.accept()
    module.hot.dispose ->
        sinks.dispose()
        sources.dispose()
