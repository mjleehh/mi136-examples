module App exposing (main)

import Html exposing (div, a, form, text, nav, span, input, label, i)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onInput, onClick)
import Browser
import Random exposing (Seed, initialSeed, step)
import Uuid exposing (Uuid, uuidGenerator)

type alias State = {
        notes: List Note,
        title: String,
        body: String,
        currentSeed: Seed
    }

initialState seed =
    {
        notes = [],
        title = "",
        body = "",
        currentSeed = initialSeed seed
    }

type Action = ADD | CHANGE_TITLE String | CHANGE_BODY String | DELETE_NOTE Uuid | NONE

reducer action state = case action of
    CHANGE_TITLE title -> {state | title = title}
    CHANGE_BODY body -> {state | body = body}
    ADD ->
        let
           (uuid, newSeed) = step uuidGenerator state.currentSeed
        in
            {state |
                notes = addNote state.notes uuid state.title state.body,
                title = "",
                body = "",
                currentSeed = newSeed
                
            }
    DELETE_NOTE uuid ->
        let
            notThisNote = isNotNote uuid
        in
            {state |
               notes = List.filter notThisNote state.notes
            }
    _ -> state


isNotNote id note = not (id == note.id)

type alias Note = {
        id: Uuid,
        title: String,
        body: String
    }

createNote id title body = {
        id = id,
        title = title,
        body = body
    }

addNote notes id title body =
    List.append notes [createNote id title body]

renderNote {id, title, body} =
    let
        handleDelete = DELETE_NOTE id
    in
        div [class "card"][
            div [class "card-content"][
                span [class "card-title"][text title],
                text body,
                div [class "card-action"][
                    a [onClick handleDelete][text "remove"]
                ]
            ]
        ]

render state =
    div[class "row"][
        nav [class "blue z-depth-0"][
            div [class "brand-logo center"][text "Notes With Dementia"]
        ],
        div[class "container row"][
            div [][
                div [class "input-field col s6"][
                    input [type_ "text", onInput CHANGE_TITLE, value state.title][],
                    label [][text "title"]
                ],
                div [class "input-field col s6"][
                    input [type_ "text", onInput CHANGE_BODY, value state.body][],
                    label [][text "note"]
                ],
                a [class "blue btn-large z-depth-0", onClick ADD][text "add"]
            ],
            div [] (List.map renderNote state.notes)
        ]
    ]


init seed =
    (
        initialState seed,
        Cmd.none
    )

update action state = (
        reducer action state,
        Cmd.none
    )

subscriptions _ = Sub.none

main = Browser.element {
        init = init,
        update = update,
        view = render,
        subscriptions = subscriptions
    }