module Reducer exposing (..)

import Action exposing (..)
import State exposing (..)
import Helpers exposing (stringToMaybe)
import Initial exposing (initialEntry)
import Ports exposing (updateMaterial, addEntry)

noCmd : a -> (a, CmdList)
noCmd state = (state, [Cmd.none])

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
uiReducer action {ui} = case action of
    SHOW_ADD -> ({ui | tab = ADD_VIEW}, [])
    SHOW_LIST -> ({ui | tab = LIST_VIEW}, [updateMaterial])
    SEARCH_CHANGED value -> noCmd {ui | search = Just value}
    RESET_SEARCH -> noCmd {ui | search = Nothing}
    ADD_CHANGED add ->
        let
            (newEntry, cmds) = newEntryReducer add ui
        in
            ({ui | newEntry = newEntry}, cmds)

dataReducer : DataAction -> State -> (State, CmdList)
dataReducer action state = case action of
    ADD_ENTRY ->
        let
            {data, ui} = state
            newData = {data | entries =  List.append data.entries [ui.newEntry]}
            newUi = {ui | newEntry = initialEntry, tab = LIST_VIEW}
        in
            ({state | ui = newUi}, [updateMaterial, addEntry ui.newEntry])
    UPDATE_ENTRIES entries ->
        let
            {data} = state
        in
            noCmd {state | data = {data | entries = entries, status = DEFAULT}}

newEntryReducer : AddAction -> UiState -> (Entry, CmdList)
newEntryReducer action {newEntry} = noCmd (case action of
    CHANGE_NEW_NAME name -> {newEntry | name = name}
    CHANGE_NEW_SURNAME surname -> {newEntry | surname = stringToMaybe surname}
    CHANGE_NEW_COMPANY company -> {newEntry | company = stringToMaybe company}
    CHANGE_NEW_EMAIL email -> {newEntry | email = email}
    CHANGE_NEW_PHONE phone -> {newEntry | phone = stringToMaybe phone})

