module Reducer exposing (..)

import Action exposing (..)
import State exposing (..)

reducer : Action -> State -> State
reducer action state = case action of
    UI ui -> {state | ui = uiReducer ui state }
    DATA data -> {state | data = dataReducer data state}
    _ -> state

uiReducer : UiAction -> State -> UiState
uiReducer action {ui} = ui

dataReducer : DataAction -> State -> DataState
dataReducer action {data} = data
