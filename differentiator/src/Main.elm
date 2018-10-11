port module App exposing (main)

import Html exposing (Html, p, text, button)
import Html.Events exposing (onClick)
import Browser

type Action = CLICK_RANDOM | SET_RANDOM Float | None

type alias State = {num: Float}



port toRandom : () -> Cmd msg
port fromRandom : (Float -> msg) -> Sub msg


init : () -> (State, Cmd msg)
init _ = (
        {num = 0.0},
        toRandom ()
    )

noCmd : State -> (State, Cmd msg)
noCmd state = (state, Cmd.none)

update : Action -> State -> (State, Cmd msg)
update action state = case action of
    CLICK_RANDOM -> (state, toRandom ())
    SET_RANDOM random -> noCmd {state | num = random}
    _ -> noCmd state

render : State -> Html Action
render state = p [][
        button [onClick CLICK_RANDOM][text "new random"],
        text "random: ",
        state.num |> String.fromFloat |> text
    ]

updateRandom : Float -> Action
updateRandom random = SET_RANDOM random

subscriptions : State -> Sub Action
subscriptions _ = fromRandom updateRandom

main = Browser.element {
        init = init,
        update = update,
        view = render,
        subscriptions = subscriptions
    }
