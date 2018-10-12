module Action exposing (..)

import State exposing (Entries, Tags)

type ModifyAction =
    CHANGE_NAME String
    | CHANGE_SURNAME String
    | CHANGE_COMPANY String
    | CHANGE_EMAIL String
    | CHANGE_PHONE String
    | CHANGE_TAGS Tags

type UiAction =
    SHOW_ADD
    | SHOW_MODIFY String
    | SHOW_LIST
    | SEARCH_CHANGED String
    | ADD_CHANGED ModifyAction
    | MODIFY_CHANGED ModifyAction
    | RESET_SEARCH

addActionWithPayload : (payload -> ModifyAction) -> payload -> Action
addActionWithPayload actionType payload = payload |> actionType |> ADD_CHANGED |> UI

modifyActionWithPayload : (payload -> ModifyAction) -> payload -> Action
modifyActionWithPayload actionType payload = payload |> actionType |> MODIFY_CHANGED |> UI

uiAction actionType = UI actionType
uiActionWithPayload actionType payload = UI (actionType payload)

type DataAction =
    ADD_ENTRY
    | MODIFY_ENTRY
    | UPDATE_ENTRIES Entries
    | REMOVE_ENTRY String

dataAction : DataAction -> Action
dataAction actionType = DATA actionType

dataActionWithPayload : (payload -> DataAction) -> payload-> Action
dataActionWithPayload actionType payload = DATA (actionType payload)

type Action = UI UiAction | DATA DataAction | NONE
