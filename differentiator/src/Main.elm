port module App exposing (main)

import Html exposing (Html, label, div, text, button, input)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onClick, onInput)
import Browser
import Debug exposing (log)
import Tokenize exposing (tokenize)
import Blocks exposing (parse)

type alias State =
    {
        f: String,
        x: Float
    }

init = {
        f = "",
        x = 0
    }

type Action = UPDATE_F String


update action state = case action of
    UPDATE_F str ->
        let
            a = log "parse" <| parse <| tokenize str
        in
            {state | f = ""}

view state = div [][
        input [onInput UPDATE_F][]
    ]

main = Browser.sandbox {
        init = init,
        update = update,
        view = view
    }
