module View exposing (render)

import Html exposing (Html, div, nav, a, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onInput)

import State exposing (State, Tabs(..))
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

renderBody state = case state.ui.tab of
    LIST_VIEW -> renderListView state
    ADD_VIEW -> renderAddView state
