module RenderModifyView exposing (renderModifyView)

import Html exposing (Html, span, text, label, input, a, p)
import Html.Attributes exposing (class, type_, value, placeholder)
import Html.Events exposing (onClick, onInput)

import State exposing (UiState)
import Action exposing (Action, modifyActionWithPayload, ModifyAction(..), DataAction(..), dataAction)

import Helpers exposing (maybeToString)

import Validate exposing (validate)
import ValidateEntry exposing (validateEntry, renderValidationErrors)
import State exposing (Entry)

renderModifyButton : Result (List String) validEntry -> Html Action
renderModifyButton validationResult =
    let
        buttonClassBase = "blue btn-large z-depth-0"
        (buttonClass, messageList) = case validationResult of
            Ok _ -> (buttonClassBase, [])
            Err err -> (buttonClassBase ++ " disabled", renderValidationErrors err)
    in
        span[class "col s12"][
            p [] messageList,
            a [class buttonClass, onClick (dataAction MODIFY_ENTRY)][text "Save"]
        ]


renderModifyView : UiState -> Html Action
renderModifyView ui =
    let
        (_, entry) = ui.modifyEntry
        surname = maybeToString entry.surname
        company = maybeToString entry.company
        phone = maybeToString entry.phone
    in
        p [class "row"][
            span [class "input-field col s5"][
                input [
                    type_ "text",
                    placeholder "name",
                    value entry.name,
                    onInput (modifyActionWithPayload CHANGE_NAME)][]
            ],
            span [class "input-field col s5"][
                input [
                    type_ "text",
                    placeholder "surname",
                    value surname,
                    onInput (modifyActionWithPayload CHANGE_SURNAME)][]
            ],
            span [class "input-field col s10"][
                input [
                    type_ "email",
                    placeholder "email",
                    value entry.email,
                    onInput (modifyActionWithPayload CHANGE_EMAIL)][]
            ],
            span [class "input-field col s10"][
                input [
                    type_ "text",
                    placeholder "phone",
                    value phone,
                    onInput (modifyActionWithPayload CHANGE_PHONE)][]
            ],
            span [class "input-field col s10"][
                input [
                    type_ "text",
                    placeholder "company",
                    value company,
                    onInput (modifyActionWithPayload CHANGE_COMPANY)][]
            ],
            renderModifyButton (validate validateEntry entry)
        ]