module App exposing (main)

import Browser
import Html exposing (div, nav, text, p, input, button, label)
import Html.Attributes exposing (class, value, id, for, type_)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Encode as Encode
import Json.Decode as Decode


type Action =
    TOGGLE_BACKLIGHT
    | UPDATE_FIRST_LINE String
    | UPDATE_SECOND_LINE String
    | UPDATED (Result Http.Error ())
    | FETCHED (Result Http.Error LcdState)

type alias LcdState = {
        firstLine: String,
        secondLine: String,
        on: Bool
    }

fetch : Cmd Action
fetch =
    Http.get {
        url = "/api/lcd"
        ,expect = Http.expectJson FETCHED decodeLcd
    }

putRequest : String -> Encode.Value -> Cmd Action
putRequest url value = Http.request {
        method = "PUT"
        ,url = url
        ,headers = []
        ,body = Http.jsonBody value
        ,expect = Http.expectWhatever UPDATED
        ,timeout = Nothing
        ,tracker = Nothing
    }

setBacklight : Bool -> Cmd Action
setBacklight value =
    putRequest "/api/backlight" <| Encode.object [
            ("on", Encode.bool value)
        ]

setFirstLine : String -> Cmd Action
setFirstLine value =
    putRequest "/api/firstline" <| Encode.object [
            ("firstLine", Encode.string value)
        ]

setSecondLine : String -> Cmd Action
setSecondLine value =
    putRequest "/api/secondline" <| Encode.object [
            ("secondLine", Encode.string value)
        ]

decodeLcd : Decode.Decoder LcdState
decodeLcd = Decode.map3 LcdState
    (Decode.field "firstLine" Decode.string)
    (Decode.field "secondLine" Decode.string)
    (Decode.field "on" Decode.bool)

init : () -> (LcdState, Cmd Action)
init flags = ({
        firstLine = String.repeat 16 " ",
        secondLine = String.repeat 16 " ",
        on = True
    }, fetch)

update action state = case action of
    TOGGLE_BACKLIGHT -> ({state | on = not state.on}, setBacklight <| not state.on)
    UPDATE_FIRST_LINE str -> ({state | firstLine = str}, setFirstLine str)
    UPDATE_SECOND_LINE str -> ({state | secondLine = str}, setSecondLine str)
    UPDATED (Ok _) -> (state, Cmd.none)
    UPDATED (Err _) -> (state, fetch)
    FETCHED (Ok newState) -> (newState, Cmd.none)
    FETCHED (Err _) -> (state, Cmd.none) -- out of options

subscriptions state = Sub.none

view state =
    let
        firstLineClass = "first-line"
        secondLineClass = "second-line"
        backlightLabel = if state.on then "backlight off" else "backlight on"
    in
        div[class "row"][
            nav [class "blue z-depth-0"][
                div [class "brand-logo center"][text "LCD Controller"]
            ]
            ,div[class "container center-align"][
                div [class "input-field"][
                    input [id firstLineClass, type_ "text", value state.firstLine, onInput UPDATE_FIRST_LINE][]
                    ,label [for firstLineClass][text "first line"]
                ]
                ,div [class "input-field"][
                    input [id secondLineClass, type_ "text", value state.secondLine, onInput UPDATE_SECOND_LINE][]
                    ,label [for secondLineClass][text "second line"]
                ]
                ,div [][
                    button [class "blue btn-large", onClick TOGGLE_BACKLIGHT][text backlightLabel]
                ]
            ]
        ]

main = Browser.element {
        init = init,
        update = update,
        view = view,
        subscriptions = subscriptions
    }