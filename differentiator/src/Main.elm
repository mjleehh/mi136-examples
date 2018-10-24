port module App exposing (main)

import Html exposing (Html, label, div, text, button, input)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick, onInput)
import Browser
import Maybe exposing (withDefault)
import Debug exposing (log)
import Tokenize exposing (tokenize)
import Blockify exposing (blockify)
import Parse exposing (parse)
import Evaluate exposing (evaluate)
import Grammar exposing (Sum)


type alias State =
    {
        f: Result String Sum,
        x: Float,
        f_y: Maybe Float
    }

init = {
        f = Err "no input",
        x = 0,
        f_y = Nothing
    }

type Action = UPDATE_F String | UPDATE_X String


update action state = case action of
    UPDATE_X xStr ->
        let
            x = withDefault 1 <| String.toFloat xStr
            f_y = case state.f of
                (Ok sum) -> Just <| evaluate x sum
                (Err _) -> Nothing
        in
            {state | x = x, f_y = f_y}
    UPDATE_F str ->
        let
            tokens = tokenize str
            f = log "f" <| case blockify tokens of
                    Ok blocks -> parse blocks
                    Err err -> log "error blockifying" Err err
        in
            {state | f = f}

view state =
    div [][
        div [][
            input [onInput UPDATE_F][]
        ],
        div [][
            input [type_ "number", onInput UPDATE_X][]
        ],
        div [][text <| String.fromFloat <| withDefault 0 <| state.f_y]
    ]

main = Browser.sandbox {
        init = init,
        update = update,
        view = view
    }
