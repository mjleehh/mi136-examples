import {Elm} from './Main.elm'

const app = Elm.App.init({node: document.getElementById('main')})

const {ports} = app

ports.toRandom.subscribe(data => {
    const newRandom = Math.random()
    ports.fromRandom.send(newRandom)
})