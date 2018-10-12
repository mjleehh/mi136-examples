module View exposing (render)

import Html exposing (Html, div, nav, a, text, p, i)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onInput)

import State exposing (State, Tabs(..), Status(..), UiState)
import Action exposing (Action, dataAction, DataAction(..), addActionWithPayload, modifyActionWithPayload, uiAction, UiAction(..))
import SearchView exposing (renderSearchView)
import ListView exposing (renderListView)
import ModifyEntry exposing (renderModifyEntry)


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
    let
        backButton = if state.ui.tab == LIST_VIEW
            then text ""
            else div [onClick (uiAction SHOW_LIST)][
                i [class "material-icons"][text "arrow_back"]]
    in
        nav [class "blue z-depth-0"][
            div [class "nav-wrapper"][
                backButton,
                a [class "brand-logo center"][text "Address Book"],
                renderSearchView state
            ]
        ]

renderAddView : State -> Html Action
renderAddView {ui} =
    renderModifyEntry "Add" addActionWithPayload (dataAction ADD_ENTRY) ui

renderModifyView : State -> Html Action
renderModifyView {ui} =
    renderModifyEntry "Modify" modifyActionWithPayload (dataAction MODIFY_ENTRY) ui


renderBody state = if state.data.status == DEFAULT
    then
        case state.ui.tab of
            LIST_VIEW -> renderListView state
            ADD_VIEW -> renderAddView state
            MODIFY_VIEW -> renderModifyView state
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