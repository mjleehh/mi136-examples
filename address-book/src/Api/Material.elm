port module Api.Material exposing (updateMaterial, fromNewTags, updateNewTags)

import State exposing (Tags)
import Action exposing (Action, addActionWithPayload, ModifyAction(..))

-- Cmd

updateMaterial : Cmd msg
updateMaterial = toMaterial ()

-- Sub

updateNewTags : Tags -> Action
updateNewTags payload = addActionWithPayload CHANGE_TAGS payload

-- ports

port toMaterial : () -> Cmd msg
port fromNewTags : (Tags -> msg) -> Sub msg