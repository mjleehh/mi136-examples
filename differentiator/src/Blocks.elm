module Blocks exposing (..)

import Tokenize exposing (Token(..), BlockDelimiter)

type Block expType = NONBLOCK expType | BLOCK (List (Block expType))

parse tokens =
    let
        loop : Maybe BlockDelimiter -> List Token -> Result String (List (Block Token), List Token)
        loop opening rest = case rest of
            (token :: newRest) -> case token of
                OPEN delimiter -> case loop (Just delimiter) newRest of
                    Ok (blockExp, afterBlock) -> case loop opening afterBlock of
                        Ok (afterBlockExp, afterCurrentBlock) ->
                            Ok (BLOCK blockExp :: afterBlockExp, afterCurrentBlock)
                        Err msg -> Err msg
                    Err msg -> Err msg
                CLOSE delimiter -> case opening of
                    Just o ->
                        if delimiter == o then
                            Ok ([], newRest) -- good
                        else
                            Err "pars missmatch" -- bad
                    _ -> Err "missing opening pars"
                _ -> case loop opening newRest of
                        Ok (restExp, afterCurrentBlock) ->
                            Ok (NONBLOCK token :: restExp, afterCurrentBlock)
                        Err str -> Err str
            [] -> case opening of
                Nothing -> Ok ([], []) -- fine
                _ -> Err "input ended before closing pars" -- bad
    in
        loop Nothing tokens
