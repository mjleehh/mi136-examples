module App exposing (main)

import Html.Events exposing (onClick)
import Browser

import State exposing (initialState)
import Reducer exposing (reducer)
import View exposing (render)

subscriptions _ = Sub.none

update action state =
    let
        (newState, cmds) = reducer action state
    in
        (newState, Cmd.batch cmds)

main = Browser.element {
        init = initialState,
        update = update,
        view = render,
        subscriptions = subscriptions
    }
