module App exposing (main)

import Html.Events exposing (onClick)
import Browser

import State exposing (initialState)
import Reducer exposing (reducer)
import View exposing (render)

main = Browser.sandbox {
        init = initialState,
        update = reducer,
        view = render
    }
