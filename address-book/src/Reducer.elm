module Reducer exposing (..)

import List.Extra
import Action exposing (..)
import State exposing (..)
import Helpers exposing (stringToMaybe)
import Initial exposing (initialEntry)
import Api.Entries exposing (addEntry, removeEntry)
import Api.Material exposing (updateMaterial)


noCmd : a -> (a, List (Cmd msg))
noCmd state = (state, [Cmd.none])

entryHasId : String -> EntryWithId -> Bool
entryHasId id (elemId, _) = elemId == id

findEntry : String -> Entries -> Maybe EntryWithId
findEntry id entries = List.Extra.find (entryHasId id) entries

reducer : Action -> State -> (State, List (Cmd Action))
reducer action state = case action of
    UI uiAction ->
        let
            (uiState, cmd) = uiReducer uiAction state
        in
            ({state | ui = uiState}, cmd)
    DATA data -> dataReducer data state
    _ -> noCmd state

uiReducer : UiAction -> State -> (UiState, List (Cmd msg))
uiReducer action {ui, data} = case action of
    SHOW_ADD -> ({ui | tab = ADD_VIEW}, [updateMaterial])
    SHOW_MODIFY id ->
        let
            maybeEntry = findEntry id data.entries
        in
            case maybeEntry of
                Just entry ->
                    noCmd {ui | tab = MODIFY_VIEW, modifyEntry = entry}
                Nothing -> noCmd ui


    SHOW_LIST -> ({ui | tab = LIST_VIEW}, [updateMaterial])
    SEARCH_CHANGED value -> noCmd {ui | search = Just value}
    RESET_SEARCH -> noCmd {ui | search = Nothing}
    ADD_CHANGED add ->
        let
            newEntry = entryReducer add ui.newEntry
        in
            noCmd {ui | newEntry = newEntry}
    MODIFY_CHANGED modify ->
        let
            (id, entry) = ui.modifyEntry
            modifyEntry = entryReducer modify entry
        in
            noCmd {ui | modifyEntry = (id, modifyEntry)}

dataReducer : DataAction -> State -> (State, (List (Cmd msg)))
dataReducer action state = case action of
    ADD_ENTRY ->
        let
            {data, ui} = state
            newData = {data | status = STORING}
            newUi = {ui | newEntry = initialEntry, tab = LIST_VIEW}
        in
            ({state | ui = newUi, data = newData}, [addEntry ui.newEntry])
    MODIFY_ENTRY ->
        let
            {data, ui} = state
            newData = {data | status = STORING}
            newUi = {ui | tab = LIST_VIEW}
        in
            ({state | ui = newUi, data = newData}, [addEntry ui.newEntry])
    UPDATE_ENTRIES entries ->
        let
            {data} = state
        in
            ({state | data = {data | entries = entries, status = DEFAULT}}, [updateMaterial])
    REMOVE_ENTRY id -> (state, [removeEntry id])

entryReducer : ModifyAction -> Entry -> Entry
entryReducer action entry = case action of
    CHANGE_NAME name -> {entry | name = name}
    CHANGE_SURNAME surname -> {entry | surname = stringToMaybe surname}
    CHANGE_COMPANY company -> {entry | company = stringToMaybe company}
    CHANGE_EMAIL email -> {entry | email = email}
    CHANGE_PHONE phone -> {entry | phone = stringToMaybe phone}
    CHANGE_TAGS tags -> {entry | tags = tags}
