module Reducer exposing (..)

import List.Extra
import Action exposing (..)
import State exposing (..)
import Helpers exposing (stringToMaybe)
import Initial exposing (initialEntry)
import Ports exposing (updateMaterial, addEntry, removeEntry)


noCmd : a -> (a, CmdList)
noCmd state = (state, [Cmd.none])

entryHasId : String -> Entry -> Bool
entryHasId id entry = case entry.id of
        Just elemId -> elemId == id
        Nothing -> False

findEntry : String -> Entries -> Maybe Entry
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

uiReducer : UiAction -> State -> (UiState, CmdList)
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
            newEntry = entryReducer add ui
        in
            noCmd {ui | newEntry = newEntry}
    MODIFY_CHANGED modify ->
        let
            modifyEntry = entryReducer modify ui
        in
            noCmd {ui | modifyEntry = modifyEntry}

dataReducer : DataAction -> State -> (State, CmdList)
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

entryReducer : ModifyAction -> UiState -> Entry
entryReducer action {newEntry} = case action of
    CHANGE_NAME name -> {newEntry | name = name}
    CHANGE_SURNAME surname -> {newEntry | surname = stringToMaybe surname}
    CHANGE_COMPANY company -> {newEntry | company = stringToMaybe company}
    CHANGE_EMAIL email -> {newEntry | email = email}
    CHANGE_PHONE phone -> {newEntry | phone = stringToMaybe phone}
    CHANGE_TAGS tags -> {newEntry | tags = tags}
