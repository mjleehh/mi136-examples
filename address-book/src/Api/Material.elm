port module Api.Material exposing (updateMaterial, tagsSubscription)

import State exposing (Tags)
import Action exposing (Action, dataActionWithPayload, DataAction(..))

-- Cmd

updateMaterial : Cmd msg
updateMaterial = toMaterial ()

-- Sub

updateTags : (String, Tags) -> Action
updateTags payload = dataActionWithPayload CHANGE_TAGS payload

-- ports

port toMaterial : () -> Cmd msg
port fromTags : ((String, Tags) -> msg) -> Sub msg

-- subs

tagsSubscription = fromTags updateTags
