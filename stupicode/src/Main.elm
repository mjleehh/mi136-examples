module App exposing (main)

import Array exposing (Array)
import Html exposing (Attribute, Html, p, text, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Browser

import Debug exposing (log)

type alias Model = {
        state: State,
        input: String,
        charCodes: Array Int,
        pos: Int,
        rest: Int,
        bytes: List Int
    }

type alias ModelWrapper = {
        model: Model,
        prev: Model
    }

initModel : Model
initModel = {
        state = START,
        input = "aÄsß",
        charCodes = Array.empty,
        pos = -1,
        rest = -1,
        bytes = []
    }

init : ModelWrapper
init = {
        model = initModel,
        prev = initModel
    }

stringToUnicodeList str =
    str |> String.toList |> List.map Char.toCode |> Array.fromList


type Action = STEP | UPDATE_INPUT | NONE

type State =
    START
    | INIT_POS
    | GET_INPUT
    | IF_NOT_AT_END
    | SET_CHAR
    | FIRST_BYTE
    | NEXT_BYTE
    | INCR_POS
    | END

nextState : Model -> Model
nextState model = case model.state of
    START -> {model | state = GET_INPUT}
    GET_INPUT -> {model | state = INIT_POS, charCodes = stringToUnicodeList model.input}
    INIT_POS -> {model | state = IF_NOT_AT_END, pos = 0}
    IF_NOT_AT_END -> if model.pos < Array.length model.charCodes
        then {model | state = SET_CHAR}
        else {model | state = END}
    SET_CHAR ->
        let
            rest = case Array.get model.pos model.charCodes of
                Just charCode -> charCode
                Nothing -> -1
        in
            {model | state = FIRST_BYTE, rest = rest}
    FIRST_BYTE ->
        let
            byte = remainderBy 128 model.rest
            newRest = model.rest // 128
        in
            {model | state = NEXT_BYTE, rest = newRest, bytes = model.bytes ++ [byte]}
    NEXT_BYTE -> if model.rest > 0
        then
            let
                value = remainderBy 128 model.rest
                byte = value + 128
                newRest = model.rest // 128
            in
                {model | state = NEXT_BYTE, rest = newRest, bytes = model.bytes ++ [byte]}
        else {model | state = INCR_POS}
    INCR_POS -> {model | state = IF_NOT_AT_END, pos = model.pos + 1}
    END -> model


update : Action -> ModelWrapper -> ModelWrapper
update action wrapper = case action of
    STEP -> {model = nextState wrapper.model, prev = wrapper.model}
    UPDATE_INPUT -> wrapper
    NONE -> wrapper

isActiveStyle : State -> Model -> Attribute Action
isActiveStyle state model = if state == model.state
    then class "activeState"
    else class "inactiveState"

ifActive : State -> Model -> String -> Html Action -> Html Action
ifActive state model title ifTrue =
    let
        body = if state == model.state
            then ifTrue
            else text ""
    in
        p [isActiveStyle state model][
            p [][text title],
            p [][body]
        ]

view : ModelWrapper -> Html Action
view wrapper =
    let
        {model, prev} = wrapper
    in
        p [][
            p [isActiveStyle START prev][text "start"],
            p [isActiveStyle GET_INPUT prev][text "get input"],
            p [isActiveStyle INIT_POS prev][text "init pos"],
            p [isActiveStyle IF_NOT_AT_END prev][
                text "if not at end ",
                text (String.fromInt prev.pos)
            ],
            p [isActiveStyle SET_CHAR prev][text "set char"],
            p [isActiveStyle FIRST_BYTE prev][text "first byte"],
            p [isActiveStyle NEXT_BYTE prev][text "next byte"],
            ifActive INCR_POS prev "increment pos" (text ((String.fromInt prev.pos) ++ "->" ++ (String.fromInt model.pos))),
            p [isActiveStyle END prev][text "end"],
            button [onClick STEP][text "step"]
        ]

main = Browser.sandbox {
        init = init,
        update = update,
        view = view
    }
