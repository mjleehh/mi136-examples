module ListView exposing (renderListView)

import Html exposing (Html, div, p, a, text, i, ul, li, button, span)
import Html.Attributes exposing (class, attribute)
import Html.Events exposing (onClick)
import State exposing (Tags, State, EntryWithId)
import Action exposing (Action(..), uiAction, uiActionWithPayload, UiAction(..), dataActionWithPayload, DataAction(..))
import Helpers exposing (maybeToString)
import Json.Encode

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

filterPredicate : String -> EntryWithId -> Bool
filterPredicate filter entryWithId =
    let
        (_, entry) = entryWithId
        lowerFilter = String.toLower filter
        lowerName = String.toLower entry.name
        lowerSurname = String.toLower (maybeToString entry.surname)
    in
        String.contains lowerFilter lowerName
        || String.contains lowerFilter lowerSurname
        || List.any (String.contains lowerFilter) entry.tags

tagsToJson : Tags -> String
tagsToJson tags = Json.Encode.list Json.Encode.string tags |> Json.Encode.encode 0

renderValue label value = if value /= ""
    then p [][
            span [class "list-label"][text label],
            span [][text value]
        ]
     else text ""

renderEntry : EntryWithId -> Html Action
renderEntry entryWithId =
    let
        (id, entry) = entryWithId
        name = entry.name
        surname = case entry.surname of
            Nothing -> ""
            Just s -> s
        editAction = dataActionWithPayload REMOVE_ENTRY id
        modifyAction = uiActionWithPayload SHOW_MODIFY id
        tags = tagsToJson entry.tags
    in
        li [][
            div [class "collapsible-header"][text name, text " ", text surname],
            div [class "collapsible-body"][
                renderValue "company " (maybeToString entry.company),
                renderValue "email:" entry.email,
                renderValue "phone:" (maybeToString entry.phone),
                p [
                    class "chips entry-tags",
                    attribute "contact-id" id,
                    attribute "contact-tags" tags
                ][],
                p [class "edit-button-container"][
                    button [class "edit-button", onClick modifyAction][text "modify"],
                    button [class "edit-button", onClick editAction][text "remove"]
                ]
            ]
        ]
