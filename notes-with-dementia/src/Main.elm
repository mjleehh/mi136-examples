module App exposing (main)

import Html exposing (div, a, form, text, nav, span, input, label, i)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onInput, onClick)
import Browser

type alias State = {
        notes: List Note,
        title: String,
        body: String
    }

initialState = {
        notes = [],
        title = "",
        body = ""
    }

type Action = ADD | CHANGE_TITLE String | CHANGE_BODY String | DELETE Int | NONE

reducer action state = case action of
    CHANGE_TITLE title -> {state | title = title}
    CHANGE_BODY body -> {state | body = body}
    ADD -> {state |
            notes = addNote state.notes state.title state.body,
            title = "",
            body = ""
        }
    DELETE index -> state
    _ -> state


type alias Note = {
        title: String,
        body: String
    }

note title body = {
        title = title,
        body = body
    }

addNote notes title body =
    List.append notes [note title body]

renderNote {title, body} =
    div [class "card"][
        div [class "card-content"][
            span [class "card-title"][text title],
            text body,
            div [class "card-action"][
                a [][text "remove"]
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


main = Browser.sandbox {
        init = initialState,
        update = reducer,
        view = render
    }