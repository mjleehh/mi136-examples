import {Elm} from './Main.elm'
import uuid from 'uuid/v4'

const SIMMULATED_DELAY = 0

const app = Elm.App.init({node: document.getElementById('main')})

const {ports} = app

const updateCollapsibles = () => {
    const accordion = true
    const collapsables = document.querySelectorAll('.collapsible')
    M.Collapsible.init(collapsables, {accordion})

    function updateNewTags(chips) {
        const chipValues = M.Chips.getInstance(chips[0])
            .getData()
            .map(({tag}) => tag)
        ports.fromNewTags.send(chipValues)
    }
    const chips = document.querySelectorAll('.add-entry-tags')
    M.Chips.init(chips, {
        placeholder: 'tags',
        onChipAdd: updateNewTags,
        onChipDelete: updateNewTags,
    })
}

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
            setTimeout(() => fromEntries.send(data), SIMMULATED_DELAY)
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
            setTimeout(() => fromEntries.send(data), SIMMULATED_DELAY)
            break
        }
    }
})
