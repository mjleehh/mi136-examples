module App exposing (main)

import Html.Events exposing (onClick)
import Browser

import State exposing (State, DataState)
import Action exposing (Action)
import Initial exposing (initialState)
import Reducer exposing (reducer)
import View exposing (render)
import Subscriptions exposing (subscriptions)


update : Action -> State -> (State, Cmd Action)
update action state =
    let
        (newState, cmds) = reducer action state
    in
        (newState, Cmd.batch cmds)

init : () -> (State, Cmd Action)
init _ =
    let (state, cmds) = initialState
    in (state, Cmd.batch cmds)

main = Browser.element {
        init = init,
        update = update,
        view = render,
        subscriptions = subscriptions
    }
