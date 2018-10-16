import {Elm} from './Main.elm'
import AddressStore from './storage'
import Material from 'materialize-css'

import "./style.scss"

const app = Elm.App.init({node: document.getElementById('main')})

const {ports} = app

const updateCollapsibles = () => {
    const accordion = true
    const collapsables = document.querySelectorAll('.collapsible')
    Material.Collapsible.init(collapsables, {
        accordion
    })

    function updateNewTags(list) {
        const chips = list[0]
        const contactId = chips.getAttribute('contact-id')
        const chipValues = Material.Chips.getInstance(chips)
            .getData()
            .map(({tag}) => tag)
        ports.fromTags.send([contactId, chipValues])
    }

    const list = document.querySelectorAll('.entry-tags')
    for (let chip of list) {
        const data = JSON.parse(chip.getAttribute('contact-tags')).map(item => ({tag: item}))
        Material.Chips.init(chip, {
            data,
            placeholder: 'tags',
            onChipAdd: updateNewTags,
            onChipDelete: updateNewTags,
        })
    }
}

ports.toMaterial.subscribe((data) => {
    // wait until elm render is done
    requestAnimationFrame(() => updateCollapsibles())
})

const store = new AddressStore()

ports.toEntries.subscribe(async (request) => {
    async function listWithoutIds() {
        const addresses = await store.list()
        return addresses.map(({id, ...item}) => [id, item])
    }

    const {fromEntries} = ports
    const [action, {id, entry, entries}] = request
    switch (action) {
        case "LIST": {
            const addresses = await listWithoutIds()
            fromEntries.send(addresses)
            break
        }
        case "ADD": {
            await store.add(entry)
            const addresses = await listWithoutIds()
            fromEntries.send(addresses)
            break
        }
        case "UPDATE": {
            await store.update(id, entry)
            const addresses = await listWithoutIds()
            fromEntries.send(addresses)
            break
        }
        case "REMOVE": {
            await store.remove(id)
            const addresses = await listWithoutIds()
            fromEntries.send(addresses)
            break
        }
    }
})
