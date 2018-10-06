port module Ports exposing (updateMaterial, loadEntries, addEntry, fromEntries)

import State exposing (Entry, Entries)

updateMaterial = toMaterial ()
port toMaterial : () -> Cmd msg

type alias MsgForEntries = (String, {entry: Maybe Entry, entries: Maybe Entries})

saveEntries : Entries -> Cmd msg
saveEntries entries = toEntries ("SAVE", {
        entry = Nothing,
        entries = Just entries
    })

loadEntries : Cmd msg
loadEntries = toEntries ("LOAD", {entry = Nothing, entries = Nothing})

addEntry : Entry -> Cmd msg
addEntry entry = toEntries ("ADD", {entry = Just entry, entries = Nothing})

port toEntries : MsgForEntries -> Cmd msg
port fromEntries : (Maybe Entries -> msg) -> Sub msg
