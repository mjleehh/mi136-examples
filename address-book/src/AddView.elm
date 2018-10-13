module AddView exposing (renderAddView)

import Html exposing (Html, span, text, label, input, a, p)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onClick, onInput)

import State exposing (UiState)
import Action exposing (Action, addActionWithPayload, ModifyAction(..), DataAction(..), dataAction)

import Helpers exposing (maybeToString)

import Validate exposing (validate)
import ValidateEntry exposing (validateEntry, renderValidationErrors)
import State exposing (Entry)


renderValidationErrors : List String -> List (Html Action)
renderValidationErrors validationErrors =
    List.map (\elem -> text elem) validationErrors

renderAddButton : Result (List String) validEntry -> Html Action
renderAddButton validationResult =
    let
        buttonClassBase = "blue btn-large z-depth-0"
        (buttonClass, messageList) = case validationResult of
            Ok _ -> (buttonClassBase, [])
            Err err -> (buttonClassBase ++ " disabled", renderValidationErrors err)
    in
        span[class "col s12"][
            p [] messageList,
            a [class buttonClass, onClick (dataAction ADD_ENTRY)][text "Add"]
        ]


renderAddView : UiState -> Html Action
renderAddView ui =
    let
        entry = ui.newEntry
        surname = maybeToString entry.surname
        company = maybeToString entry.company
        phone = maybeToString entry.phone
    in
        p [class "row"][
            span [class "input-field col s5"][
                input [type_ "text", value entry.name, onInput (addActionWithPayload CHANGE_NAME)][],
                label [][text "name"]
            ],
            span [class "input-field col s5"][
                input [type_ "text", value surname, onInput (addActionWithPayload CHANGE_SURNAME)][],
                label [][text "surname"]
            ],
            span [class "input-field col s10"][
                input [type_ "email", value entry.email, onInput (addActionWithPayload CHANGE_EMAIL)][],
                label [][text "email"]
            ],
            span [class "input-field col s10"][
                input [type_ "text", value phone, onInput (addActionWithPayload CHANGE_PHONE)][],
                label [][text "phone"]
            ],
            span [class "input-field col s10"][
                input [type_ "text", value company, onInput (addActionWithPayload CHANGE_COMPANY)][],
                label [][text "company"]
            ],
            renderAddButton (validate validateEntry entry)
        ]