module Blockify exposing (blockify, Block(..))

import Tokenize exposing (Token(..), BlockDelimiter)

type Block = NONBLOCK Token | BLOCK (List Block)

blockify : List Token -> Result String (List Block)
blockify tokens =
    let
        loop : Maybe BlockDelimiter -> List Token -> Result String (List Block, List Token)
        loop opening rest = case rest of
            (token :: newRest) -> case token of
                OPEN delimiter -> case loop (Just delimiter) newRest of
                    Ok (blockExp, afterBlock) -> case loop opening afterBlock of
                        Ok (afterBlockExp, afterCurrentBlock) ->
                            Ok (BLOCK blockExp :: afterBlockExp, afterCurrentBlock)
                        Err err -> Err err
                    Err err -> Err err
                CLOSE delimiter -> case opening of
                    Just o ->
                        if delimiter == o then
                            Ok ([], newRest)
                        else
                            Err "pars missmatch"
                    _ -> Err "missing opening pars"
                _ -> case loop opening newRest of
                        Ok (restExp, afterCurrentBlock) ->
                            Ok (NONBLOCK token :: restExp, afterCurrentBlock)
                        Err err -> Err err
            [] -> case opening of
                Nothing -> Ok ([], [])
                _ -> Err "input ended before closing pars"
    in
        case loop Nothing tokens of
            Ok (res, _) -> Ok res
            Err err -> Err err

