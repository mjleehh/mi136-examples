module Subscriptions exposing (subscriptions)

import State exposing (State, Entries, Tags)
import Action exposing (Action(..), dataActionWithPayload, DataAction(..), addActionWithPayload, ModifyAction(..))
import Ports exposing (fromEntries, fromNewTags)

updateData : Maybe Entries -> Action
updateData payload = case payload of
    Just entries -> dataActionWithPayload UPDATE_ENTRIES entries
    Nothing -> NONE

updateNewTags : Tags -> Action
updateNewTags payload = addActionWithPayload CHANGE_TAGS payload


subscriptions : State -> Sub Action
subscriptions _ = Sub.batch [
        fromEntries updateData,
        fromNewTags updateNewTags
    ]