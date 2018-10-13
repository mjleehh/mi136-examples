port module Api.Entries exposing (loadEntries, addEntry, removeEntry, fromEntries, updateEntry, entriesUpdated)

import State exposing (Entry, EntryWithId, Entries)
import Action exposing (Action(..), dataActionWithPayload, DataAction(..))

-- Cmd

type alias Request = (String, RequestData)

type alias RequestData = {
        id: Maybe String,
        entry: Maybe Entry,
        entries: Maybe Entries
    }

sendCommand : String -> RequestData -> Cmd msg
sendCommand cmd data = toEntries (cmd, data)

loadEntries : Cmd msg
loadEntries = sendCommand "LIST" {
        id = Nothing,
        entry = Nothing,
        entries = Nothing
    }


addEntry : Entry -> Cmd msg
addEntry entry = sendCommand "ADD" {
        id = Nothing,
        entry = Just entry,
        entries = Nothing
    }

updateEntry : EntryWithId -> Cmd msg
updateEntry (id, entry) = sendCommand "UPDATE" {
        id = Just id,
        entry = Just entry,
        entries = Nothing
    }

removeEntry : String -> Cmd msg
removeEntry id = sendCommand "REMOVE" {
        id = Just id,
        entry = Nothing,
        entries = Nothing
    }

-- Sub

entriesUpdated : Maybe Entries -> Action
entriesUpdated payload = case payload of
    Just entries -> dataActionWithPayload UPDATE_ENTRIES entries
    Nothing -> NONE

-- ports

port toEntries : Request -> Cmd msg
port fromEntries : (Maybe Entries -> msg) -> Sub msg
