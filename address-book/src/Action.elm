module Action exposing (..)

type AddAction =
    CHANGE_NEW_NAME String
    | CHANGE_NEW_SURNAME String
    | CHANGE_NEW_COMPANY String
    | CHANGE_NEW_EMAIL String
    | CHANGE_NEW_PHONE String
addAction actionType = actionType |> ADD_CHANGED |> UI
addActionWithArg actionType arg = arg |> actionType |> ADD_CHANGED |> UI

type UiAction =
    SHOW_ADD
    | SHOW_LIST
    | SEARCH_CHANGED String
    | ADD_CHANGED AddAction
    | RESET_SEARCH

uiAction actionType = UI actionType
uiActionWithArg actionType arg = UI (actionType arg)

type DataAction = ADD_ENTRY

dataAction actionType = DATA actionType

type Action = UI UiAction | DATA DataAction | NONE
