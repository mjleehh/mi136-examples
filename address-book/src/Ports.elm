port module Ports exposing (updateMaterial, loadData, saveData, fromStorage)

import State exposing (DataState)

updateMaterial = toMaterial ()
port toMaterial : () -> Cmd msg

type alias MsgForStorage = (String, Maybe DataState)

saveData : DataState -> Cmd msg
saveData data = toStorage ("SAVE", Just data)
loadData = toStorage ("LOAD", Nothing)

port toStorage : MsgForStorage -> Cmd msg
port fromStorage : (Maybe DataState -> msg) -> Sub msg

