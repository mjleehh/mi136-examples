module SearchView exposing (renderSearchView)

import Html exposing (Html, form, div, input, label, i, text)
import Html.Attributes exposing (class, type_, value, id, for)
import Html.Events exposing (onClick, onInput)

import State exposing (State)
import Action exposing (Action, uiAction, uiActionWithPayload, UiAction(..))

renderSearchView : State -> Html Action
renderSearchView {ui} =
    let
        search = case ui.search of
            Just s -> s
            Nothing -> ""
    in
        form [class "right"][
            div [class "input-field"][
                 input [id "search", type_ "search", value search, onInput (uiActionWithPayload SEARCH_CHANGED)][],
                 label [class "label-icon", for "search"][i [class "material-icons"][text "search"]],
                 i [class "material-icons", onClick (uiAction RESET_SEARCH)][text "close"]
            ]
        ]