module AddView exposing (renderAddView)

import Html exposing (Html, div, text, label, input, a, p)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onClick, onInput)

import State exposing (State)
import Action exposing (Action, addActionWithArg, addAction, AddAction(..), dataAction, DataAction(..))

import Helpers exposing (maybeToString)

renderAddView : State -> Html Action
renderAddView {ui} =
    let
        entry = ui.newEntry
        surname = maybeToString entry.surname
        company = maybeToString entry.company
        phone = maybeToString entry.phone
    in
        div [class "row"][
            div [][
                div [class "input-field col s6"][
                    input [type_ "text", value entry.name, onInput (addActionWithArg CHANGE_NEW_NAME)][],
                    label [][text "name"]
                ],
                div [class "input-field col s6"][
                    input [type_ "text", value surname, onInput (addActionWithArg CHANGE_NEW_SURNAME)][],
                    label [][text "surname"]
                ],
                div [class "input-field col s6"][
                    input [type_ "text", value company, onInput (addActionWithArg CHANGE_NEW_COMPANY)][],
                    label [][text "company"]
                ],
                div [class "input-field col s6"][
                    input [type_ "text", value entry.email, onInput (addActionWithArg CHANGE_NEW_EMAIL)][],
                    label [][text "email"]
                ],
                div [class "input-field col s12"][
                    input [type_ "text", value phone, onInput (addActionWithArg CHANGE_NEW_PHONE)][],
                    label [][text "phone"]
                ],
                div [class "input-field col s12"][
                    div [class "chips add-entry-tags"][]
                ]
            ],
            div [][
                a [class "blue btn-large z-depth-0", onClick (dataAction ADD_ENTRY)][text "add"]
            ]
        ]