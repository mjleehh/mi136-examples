module Subscriptions exposing (subscriptions)

import State exposing (State, Entries, Tags)
import Action exposing (Action(..), dataActionWithArg, DataAction(..), addActionWithArg, AddAction(..))
import Ports exposing (fromEntries, fromNewTags)

updateData : Maybe Entries -> Action
updateData payload = case payload of
    Just entries -> dataActionWithArg UPDATE_ENTRIES entries
    Nothing -> NONE

updateNewTags : Tags -> Action
updateNewTags payload = addActionWithArg CHANGE_NEW_TAGS payload


subscriptions : State -> Sub Action
subscriptions _ = Sub.batch [
        fromEntries updateData,
        fromNewTags updateNewTags
    ]