import {Elm} from './Main.elm'
import uuid from 'uuid/v4'


const updateCollapsibles = () => {
    const accordion = true
    const collapsables = document.querySelectorAll('.collapsible')
    M.Collapsible.init(collapsables, {accordion})
}

console.log(uuid())

const app = Elm.App.init({node: document.getElementById('main')})



const {ports} = app
ports.toMaterial.subscribe((data) => {
    requestAnimationFrame(() => updateCollapsibles())
})


ports.toEntries.subscribe((data) => {
    const {fromEntries} = ports
    const ENTRIES_KEY = 'entries'
    const [action, {entry, entries}] = data
    switch (action) {
        case "ADD": {
            const str = localStorage.getItem(ENTRIES_KEY)
            const data = JSON.parse(str) || []
            const newEntry = {...entry, id: uuid()}
            data.push(newEntry)
            localStorage.setItem(ENTRIES_KEY, JSON.stringify(data))
            fromEntries.send(data)
            break
        }
        case "SAVE": {
            localStorage.setItem(ENTRIES_KEY, JSON.stringify(entries))
            fromEntries.send(entries)
            break
        }
        case "LOAD": {
            const str = localStorage.getItem(ENTRIES_KEY)
            const data = JSON.parse(str)
            fromEntries.send(data)
            break
        }
    }
})
