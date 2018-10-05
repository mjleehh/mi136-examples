module Subscriptions exposing (subscriptions)

import State exposing (State, DataState)
import Action exposing (Action(..), dataActionWithArg, DataAction(..))
import Ports exposing (fromStorage)

updateData : Maybe DataState -> Action
updateData payload = case payload of
    Just data -> dataActionWithArg NEW_DATA data
    Nothing -> NONE


subscriptions : State -> Sub Action
subscriptions _ = fromStorage updateData