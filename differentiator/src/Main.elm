port module App exposing (main)

import Html exposing (Html, label, div, text, button, input)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick, onInput)
import Browser

process : String -> Float -> (Float, String, Float)
process function x = (0, "", 0)


type Action = FUNCTION_CHANGED String | X_CHANGED String | PROCESS

type alias State =
    {
        f: String,
        x: Float,
        f_y: Maybe Float,
        df: Maybe String,
        df_y: Maybe Float
    }


init = {
        f = "",
        x = 0,
        f_y = Nothing,
        df = Nothing,
        df_y = Nothing
    }

update action state = case action of
    FUNCTION_CHANGED value -> {state | f = value, f_y = Nothing, df = Nothing, df_y = Nothing}
    X_CHANGED value -> state
    PROCESS ->
        let
            (f_y, df, df_y) = process state.f state.x
        in
            {state | f_y = Just f_y, df = Just df, df_y = Just df_y}

    printStringMaybe maybe = case maybe of
        Just value -> text value
        Nothing -> text " "

    printFloatMaybe maybe = case maybe of
        Just value -> text (String.fromFloat value)
        Nothing -> text " "view state =
    let
        printStringMaybe maybe = case maybe of
            Just value -> text value
            Nothing -> text " "

        printFloatMaybe maybe = case maybe of
            Just value -> text (String.fromFloat value)
            Nothing -> text " "
    in
        div [][
            div [][
                label [][text "function"],
                input [type_ "text", onInput FUNCTION_CHANGED, value state.f][]
            ],
            div [][
                label [][text "x"],
                input [type_ "number", onInput X_CHANGED][]
            ],
            div [][button [][text "process"]],
            div [][printFloatMaybe state.f_y],
            div [][printStringMaybe state.df],
            div [][printFloatMaybe state.df_y]
        ]

main = Browser.sandbox {
        init = init,
        update = update,
        view = view
    }
