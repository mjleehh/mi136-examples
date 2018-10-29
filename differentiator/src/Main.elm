port module App exposing (main)

import Html exposing (Html, label, div, text, button, input, i, li, p, ul, a)
import Html.Attributes exposing (type_, value, class, disabled)
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
        f: String
        ,x: Float
        ,f_y: Maybe Float
        ,history: List Sum
    }

init : State
init = {
        f = ""
        ,x = 0
        ,f_y = Nothing
        ,history = []
    }

type Action = UPDATE_F String | UPDATE_X String | PUSH_TO_HISTORY | INPUT_FROM_HISTORY Sum

update : Action -> State -> State
update action state = case action of
    PUSH_TO_HISTORY -> case parseF state of
        Ok f -> {state | history = f :: state.history, f = ""}
        Err _ -> state
    INPUT_FROM_HISTORY f -> {state | f = render f}
    UPDATE_X xStr ->
        let
            x = withDefault 1 <| String.toFloat xStr
            f_y = case parseF state of
                (Ok sum) -> Just <| evaluate x sum
                (Err _) -> Nothing
        in
            {state | x = x, f_y = f_y}
    UPDATE_F str ->
        {state | f = str}

parseF : State -> Result String Sum
parseF state =
    let
        tokens = tokenize state.f
        f = case blockify tokens of
            Ok blocks -> parse blocks
            Err err -> log "error blockifying" Err err
    in
        f

view : State -> Html Action
view state =
    let
        f = parseF state

        fRender = case f of
            Ok func -> render func
            Err err -> err
        simple_f = case f of
            Ok func -> render <| simplify func
            Err _ -> ""
        df = case f of
            Ok func -> Ok <| differentiate func
            Err err -> Err err
        dfRender = case df of
            Ok func -> render <| func
            Err _ -> ""
        simple_df = case df of
            Ok func -> render <| simplify func
            Err _ -> ""
        addButtonClasses = case f of
            Ok _ -> disabled False
            Err _ -> disabled True


        renderF func = li [class "collection-item", onClick <| INPUT_FROM_HISTORY func][
                div [][
                text <| render func
                ,a [class "secondary-content"][text "f'"]
                ]
            ]

        history = List.map renderF state.history

    in
        div [class "container"][
            div [class "row"][
                input [class "col s11", onInput UPDATE_F, value state.f][]
                ,button [class "btn", addButtonClasses, onClick PUSH_TO_HISTORY] [i [class "large material-icons"][text "navigate_next"]]
            ]
            ,input [type_ "number", onInput UPDATE_X][]
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
            ,ul [class "collection"] history
        ]

main = Browser.sandbox {
        init = init,
        update = update,
        view = view
    }
