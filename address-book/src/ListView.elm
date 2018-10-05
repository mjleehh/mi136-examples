module ListView exposing (renderListView)

import Html exposing (Html, div, p, a, text, i, ul, li, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import State exposing (State, Entry)
import Action exposing (Action, uiAction, uiActionWithArg, UiAction(..))

renderListView : State -> Html Action
renderListView state =
    p [][
        renderList state,
        div [class "fixed-action-btn"][
            a [class "btn-floating btn-large red", onClick (uiAction SHOW_ADD)][i [class "material-icons"][text "add"]]
        ]
    ]

renderList : State -> Html Action
renderList {data} =
    ul [class "collapsible"] (List.map renderEntry data.entries)

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
                p [][text "company"],
                p [][text "company"],
                p [][text "ouccompany"],
                p [][text "company"],
                p [][
                    button [class "btn-large-floating"][text "remove"]
                ]
            ]
        ]
