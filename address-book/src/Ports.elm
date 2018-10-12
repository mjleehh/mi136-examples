port module Ports exposing (updateMaterial, loadEntries, addEntry, removeEntry, fromEntries, fromNewTags)

import State exposing (Entry, Entries, Tags)

updateMaterial = toMaterial ()
port toMaterial : () -> Cmd msg

port fromNewTags : (Tags -> msg) -> Sub msg

type alias MsgForEntries = (String, {id: Maybe String, entry: Maybe Entry, entries: Maybe Entries})

saveEntries : Entries -> Cmd msg
saveEntries entries = toEntries ("SAVE", {
        id = Nothing,
        entry = Nothing,
        entries = Just entries
    })

loadEntries : Cmd msg
loadEntries = toEntries ("LOAD", {
        id = Nothing,
        entry = Nothing,
        entries = Nothing
    })

addEntry : Entry -> Cmd msg
addEntry entry = toEntries ("ADD", {
        id = Nothing,
        entry = Just entry,
        entries = Nothing
    })

removeEntry : String -> Cmd msg
removeEntry id = toEntries("REMOVE", {
        id = Just id,
        entry = Nothing,
        entries = Nothing
    })

port toEntries : MsgForEntries -> Cmd msg
port fromEntries : (Maybe Entries -> msg) -> Sub msg
