module View exposing (..)

import Html exposing (Html, div, nav, p, text, button, a)
import Html.Attributes exposing (class)

import State exposing (State, Entry)
import Action exposing (Action)

render : State -> Html Action
render state =
    div[class "row"][
        renderHeader,
        div[class "container row"][
            renderListView state
        ]
    ]

renderHeader =
    nav [class "blue z-depth-0"][
        div [class "brand-logo center"][text "Address Book"]
    ]

renderListView : State -> Html Action
renderListView state =
    p [][
        button [class "btn-large red"][text "add"],
        renderList state
    ]

renderList : State -> Html Action
renderList {data} =
    p [] (List.map renderEntry data.entries)

renderEntry : Entry -> Html Action
renderEntry entry =
    let
        name = entry.name
        surname = case entry.surname of
            Nothing -> ""
            Just s -> s
    in
        p [][
            div [class "card"][
                div [class "card-content"][
                    p [class "card-title"][text name, text " ", text surname],
                    p [][text "body"],
                    div [class "card-action"][
                        a [][text "remove"]
                    ]
                ]
            ]
        ]