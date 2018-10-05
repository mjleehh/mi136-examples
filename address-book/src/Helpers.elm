module Helpers exposing (..)

maybeToString maybe = case maybe of
    Just value -> value
    Nothing -> ""

stringToMaybe maybeString = if maybeString == ""
    then Nothing
    else Just maybeString