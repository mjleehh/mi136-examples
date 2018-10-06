module Subscriptions exposing (subscriptions)

import State exposing (State, Entries)
import Action exposing (Action(..), dataActionWithArg, DataAction(..))
import Ports exposing (fromEntries)

updateData : Maybe Entries -> Action
updateData payload = case payload of
    Just entries -> dataActionWithArg UPDATE_ENTRIES entries
    Nothing -> NONE


subscriptions : State -> Sub Action
subscriptions _ = fromEntries updateData