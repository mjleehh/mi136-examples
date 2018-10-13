import {Elm} from './Main.elm'
import AddressStore from './storage'


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

const store = new AddressStore()

ports.toEntries.subscribe(async (request) => {
    async function listWithoutIds() {
        const addresses = await store.list()
        return addresses.map(({id, ...item}) => [id, item])
    }

    const {fromEntries} = ports
    const ENTRIES_KEY = 'entries'
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
