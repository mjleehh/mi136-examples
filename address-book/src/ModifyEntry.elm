module ModifyEntry exposing (renderModifyEntry)

import Html exposing (Html, div, text, label, input, a, p)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onClick, onInput)

import State exposing (UiState)
import Action exposing (Action, ModifyAction(..))

import Helpers exposing (maybeToString)

import Validate exposing (validate)
import ValidateEntry exposing (validateEntry)
import State exposing (Entry)


renderValidationErrors : List String -> List (Html Action)
renderValidationErrors validationErrors =
    List.map (\elem -> text elem) validationErrors

renderAddButton : String -> Action -> Result (List String) validEntry -> Html Action
renderAddButton label action validationResult =
    let
        buttonClassBase = "blue btn-large z-depth-0"
        (buttonClass, messageList) = case validationResult of
            Ok _ -> (buttonClassBase, [])
            Err err -> (buttonClassBase ++ " disabled", renderValidationErrors err)
    in
        div[class "col s12"][
            p [] messageList,
            a [class buttonClass, onClick action][text label]
        ]


renderModifyEntry : String -> ((String -> ModifyAction) -> String -> Action) -> Action -> UiState -> Html Action
renderModifyEntry confirmButtonLabel modifyAction confirmAction ui =
    let
        entry = ui.newEntry
        surname = maybeToString entry.surname
        company = maybeToString entry.company
        phone = maybeToString entry.phone
    in
        div [class "row"][
            div [class "input-field col s6"][
                input [type_ "text", value entry.name, onInput (modifyAction CHANGE_NAME)][],
                label [][text "name"]
            ],
            div [class "input-field col s6"][
                input [type_ "text", value surname, onInput (modifyAction CHANGE_SURNAME)][],
                label [][text "surname"]
            ],
            div [class "input-field col s6"][
                input [type_ "text", value company, onInput (modifyAction CHANGE_COMPANY)][],
                label [][text "company"]
            ],
            div [class "input-field col s6"][
                input [type_ "email", value entry.email, onInput (modifyAction CHANGE_EMAIL)][],
                label [][text "email"]
            ],
            div [class "input-field col s12"][
                input [type_ "text", value phone, onInput (modifyAction CHANGE_PHONE)][],
                label [][text "phone"]
            ],
            div [class "input-field col s12"][
                div [class "chips add-entry-tags"][]
            ],
            renderAddButton confirmButtonLabel confirmAction (validate validateEntry entry)
        ]