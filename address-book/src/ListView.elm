module ListView exposing (renderListView)

import Html exposing (Html, div, p, a, text, i, ul, li, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import State exposing (State, Entry)
import Action exposing (Action, uiAction, uiActionWithArg, UiAction(..))
import Helpers exposing (maybeToString)


renderListView : State -> Html Action
renderListView state =
    p [][
        renderList state,
        div [class "fixed-action-btn"][
            a [class "btn-floating btn-large red", onClick (uiAction SHOW_ADD)][i [class "material-icons"][text "add"]]
        ]
    ]

renderList : State -> Html Action
renderList state =
    ul [class "collapsible"] (List.map renderEntry (filterList state))


filterList {ui, data} = case ui.search of
    Nothing -> data.entries
    Just filter -> List.filter (filterPredicate filter) data.entries

filterPredicate : String -> Entry -> Bool
filterPredicate filter entry =
    let
        lowerFilter = String.toLower filter
        lowerName = String.toLower entry.name
        lowerSurname = String.toLower (maybeToString entry.surname)
    in
        String.contains lowerFilter lowerName || String.contains lowerFilter lowerSurname

renderEntry : Entry -> Html Action
renderEntry entry =
    let
        name = entry.name
        surname = case entry.surname of
            Nothing -> ""
            Just s -> s
    in
        li [][
            div [class "collapsible-header"][text name, text " ", text surname],
            div [class "collapsible-body"][
                p [][text "company: ", text (maybeToString entry.company)],
                p [][text "email", text entry.email],
                p [][text "phone", text (maybeToString entry.phone)],
                p [][text "tags"],
                p [][
                    button [class "btn-large-floating"][text "remove"]
                ]
            ]
        ]
