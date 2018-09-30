module Action exposing (..)

type UiAction = SHOW_ADD | SHOW_LIST

type DataAction = ADD_ENTRY

type Action = UI UiAction | DATA DataAction | NONE
