module App exposing (main)

import Html exposing (Html, div, nav, button, text, p, input)
import Html.Attributes exposing (class, type_, min, max, value)
import Html.Events exposing (onClick)
import Browser

type alias State = {
        counter: Int
    }

initialState : State
initialState =
    {
        counter = 0
    }

type Action = INCREMENT | DECREMENT | RESET | NONE

reducer : Action -> State -> State
reducer action state = case action of
    RESET -> {state | counter = 0}
    INCREMENT -> if state.counter >= 10
        then state
        else {state | counter = state.counter + 1}
    DECREMENT -> if state.counter <= -10
        then state
        else {state | counter = state.counter - 1}
    _ -> state

render : State -> Html Action
render state =
    div[class "row"][
        nav [class "blue z-depth-0"][
            div [class "brand-logo center"][text "Counter"]
        ],
        div[class "container row center-align"][
            p [][
                div [class "chip"][text (String.fromInt state.counter)]
            ],
            p [][
                input [type_ "range", min "-10", max "10", value (String.fromInt state.counter)][]
            ],
            p [][
                div [class "column"][
                    button [class "blue btn-large", onClick DECREMENT][text "decrement"],
                    text " ",
                    button [class "blue btn-large", onClick RESET][text "reset"],
                    text " ",
                    button [class "blue btn-large", onClick INCREMENT][text "increment"]
                ]
            ]
        ]
    ]

main = Browser.sandbox {
        init = initialState,
        update = reducer,
        view = render
    }