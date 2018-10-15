module App exposing (main)

import Array exposing (Array)
import Html exposing (Attribute, Html, p, text, button, span, div, nav, main_, footer, ul, li, input)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onClick, onInput)
import Browser

import Debug exposing (log)

import Bitwise

-- model

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

-- actions

type Action = STEP | UPDATE_INPUT String | NONE

-- udpate

stringToUnicodeList str =
    str |> String.toList |> List.map Char.toCode |> Array.fromList

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
    UPDATE_INPUT s ->
        let
            {model} = wrapper
            newModel = {model | input = s}
        in
            {wrapper | model = newModel}
    NONE -> wrapper

-- view

view : ModelWrapper -> Html Action
view wrapper =
    div [class "app"][
        nav [][
           div [class "nav-wrapper"][
                div [class "brand-logo app-name"][text "Stupicode"],
                ul [class "right"][
                    li [][button [class "btn", onClick STEP][text "next"]],
                    li [][button [class "btn"][text "autoplay"]]
                ]
           ]
        ],
        main_ [class "container"][
            div[][
                renderInput wrapper.model,
                renderModel wrapper.model,
                renderBytes wrapper.model.bytes,
                renderStates wrapper
            ]
        ],
        footer [class "page-footer"][
            div [][text "© Michael Jonathan Lee"]
        ]
    ]

renderInput : Model -> Html Action
renderInput model = if model.state == GET_INPUT
    then
        div [][
            div [class "input-field"][
                input [value model.input, onInput UPDATE_INPUT][]
            ]
        ]
    else
        div [][]

renderInt : Int -> Html Action
renderInt n =
    text (String.fromInt n)

renderModel : Model -> Html Action
renderModel model = div [][
        ul [class "collection with-header modelview"][
            li [class "collection-item"][
                span [class "badge"][text model.input],
                span [][text "input:"]
            ],
            li [class "collection-item"][
                span [class "badge"][renderInt model.pos],
                span [][text "n:"]
            ],
            li [class "collection-item"][
                span [class "badge"][renderInt model.rest],
                span [][text "rest:"]
            ]
        ]
    ]

renderStates : ModelWrapper -> Html Action
renderStates wrapper =
    let
        {model, prev} = wrapper
        renderState state caption =
            let
                cardClass = if state == model.state
                    then class "card col s3 activestate"
                    else class "card col s3"
            in
                div [cardClass][
                    div [class "card-content"][text caption],
                    div [class "card-action"][text "bar"]
                ]
    in
        div [class "row"][
            renderState START "start",
            renderState GET_INPUT "S := input",
            renderState INIT_POS "n := 0",
            renderState IF_NOT_AT_END "if n < len(S)",
            renderState SET_CHAR "s := S[n]",
            renderState FIRST_BYTE "first byte",
            renderState NEXT_BYTE "subsequent byte",
            renderState INCR_POS "n := n + 1",
            renderState END "end"
        ]


-- due to a bug in Bitwise.and we have to workaround
getBits : List Int -> Int -> List Int
getBits bits byte =
    if List.length bits < 8
    then
        let
            mask = Bitwise.shiftLeftBy (7 - List.length bits) 1
            newByte = remainderBy mask byte
            value = byte // mask
        in
            getBits (bits ++ [value]) newByte
    else
        bits

renderByte : Int -> Html Action
renderByte byte =
    let
        bits =getBits [] byte
    in
        div [] (List.map (\bit -> span [][text (String.fromInt bit)]) bits)

renderBytes : List Int -> Html Action
renderBytes bytes = div [] (List.map renderByte bytes)

-- main

main = Browser.sandbox {
        init = init,
        update = update,
        view = view
    }
