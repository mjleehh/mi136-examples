module View exposing (render)

import Html exposing (Html, div, nav, a, text, p)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onInput)

import State exposing (State, Tabs(..), Status(..))
import Action exposing (Action)
import SearchView exposing (renderSearchView)
import ListView exposing (renderListView)
import AddView exposing (renderAddView)

render : State -> Html Action
render state =
    div[class "row"][
        renderHeader state,
        div[class "row container"][
            renderBody state
        ]
    ]

renderHeader : State -> Html Action
renderHeader state =
    nav [class "blue z-depth-0"][
        div [class "nav-wrapper"][
            a [class "brand-logo center"][text "Address Book"],
            renderSearchView state
        ]
    ]

renderBody state = if state.data.status == DEFAULT
    then
        case state.ui.tab of
            LIST_VIEW -> renderListView state
            ADD_VIEW -> renderAddView state
    else
        p [class "center"][
            div [class "preloader-wrapper big active"][
                div [class "spinner-layer spinner-blue-only"][
                    div [class "circle-clipper left"][
                        div [class "circle"][]
                    ],
                    div [class "gap-patch"][
                      div [class "circle"][]
                    ],
                    div [class "circle-clipper right"][
                      div [class "circle"][]
                    ]
                ]
            ]
        ]