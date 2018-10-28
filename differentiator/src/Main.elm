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
import Render exposing (render)
import Differentiate exposing (differentiate)
import Simplify exposing (simplify)

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
            f = case blockify tokens of
                    Ok blocks -> parse blocks
                    Err err -> log "error blockifying" Err err
        in
            {state | f = f}

view state =
    let
        fRender = case state.f of
            Ok func -> render func
            Err err -> err
        simple_f = case state.f of
            Ok func -> render <| simplify func
            Err _ -> ""
        df = case state.f of
            Ok func -> Ok <| differentiate func
            Err err -> Err err
        dfRender = case df of
            Ok func -> render <| func
            Err _ -> ""
        simple_df = case df of
            Ok func -> render <| simplify func
            Err _ -> ""

    in
        div [][
            div [][
                input [onInput UPDATE_F][]
            ]
            ,div [][
                input [type_ "number", onInput UPDATE_X][]
            ]
            ,div [][text "f(x)"]
            ,div [][text <| String.fromFloat <| withDefault 0 <| state.f_y]
            ,div [][text "f"]
            ,div [][text fRender]
            ,div [][text "simplified f"]
            ,div [][text simple_f]
            ,div [][text "f'"]
            ,div [][text dfRender]
            ,div [][text "simplified f'"]
            ,div [][text simple_df]
        ]

main = Browser.sandbox {
        init = init,
        update = update,
        view = view
    }
