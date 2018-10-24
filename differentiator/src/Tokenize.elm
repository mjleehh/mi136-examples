module Tokenize exposing (tokenize, Token(..), BlockDelimiter, Operator(..))

import Debug exposing (log)
import Maybe exposing (withDefault)
import Helpers exposing (push)
import Grammar exposing (Function(..))

type Token =
    NUMBER Float
    | OPERATOR Operator
    | OPEN BlockDelimiter
    | CLOSE BlockDelimiter
    | X
    | FUNCTION Function
    | NULL_TOKEN

type Operator =
    PLUS
    | MINUS
    | TIMES
    | DIVISION
    | MODULO
    | POWER



type BlockDelimiter = PARENTHESES | BRACKETS | BRACES

getOperator : Char -> Maybe Token
getOperator c = case c of
    '+' -> Just <| OPERATOR PLUS
    '-' -> Just <| OPERATOR MINUS
    '*' -> Just <| OPERATOR TIMES
    '/' -> Just <| OPERATOR DIVISION
    '%' -> Just <| OPERATOR MODULO
    '^' -> Just <| OPERATOR POWER
    _ -> Nothing

getOpen : Char -> Maybe Token
getOpen c = case c of
    '(' -> Just <| OPEN PARENTHESES
    '[' -> Just <| OPEN BRACKETS
    '{' -> Just <| OPEN BRACES
    _ -> Nothing

getClose : Char -> Maybe Token
getClose c = case c of
    ')' -> Just <| CLOSE PARENTHESES
    ']' -> Just <| CLOSE BRACKETS
    '}' -> Just <| CLOSE BRACES
    _ -> Nothing

feedFunction first initialRest =
    let
        loop acc rest = case rest of
            (c :: newRest) ->
                if Char.isAlphaNum c then
                    loop (push acc c) newRest
                else
                    (isFunction acc, rest)
            [] -> (isFunction acc, [])
        isFunction f = case String.fromList f of
            "x" -> X
            "sin" -> FUNCTION SIN
            "cos" -> FUNCTION COS
            "tan" -> FUNCTION TAN
            "ln" -> FUNCTION LN
            "exp" -> FUNCTION EXP
            _ -> NULL_TOKEN


    in
        loop [first] initialRest

feedNumber : Char -> List Char -> (Token, List Char)
feedNumber first initialRest =
    let
        tokenFromNumbers acc = case String.toFloat <| String.fromList acc of
            Just float -> NUMBER float
            Nothing -> NULL_TOKEN
        loop acc pastDot rest = case rest of
            (c :: newRest) ->
                if c == '.' then
                    if pastDot then
                        (NULL_TOKEN, newRest)
                    else
                        loop (push acc '.') True newRest
                else if Char.isDigit c then
                   loop (push acc c) pastDot newRest
                else
                   (tokenFromNumbers acc, rest)
            [] -> (tokenFromNumbers acc, [])
    in
        loop [first] (first == '.') initialRest

tokenize : String -> List Token
tokenize str =
    let
        feedSpaces rest = case rest of
            (c :: newRest) ->
                if c == ' ' then
                    feedSpaces newRest
                else
                    loop rest
            [] -> []

        feedNext current rest = current :: loop rest
        loop rest = case rest of
            (c :: newRest) ->
                let
                    operator = withDefault NULL_TOKEN <| getOperator c
                    open = withDefault NULL_TOKEN <| getOpen c
                    close = withDefault NULL_TOKEN <| getClose c
                in
                    if c == 'x' then
                        feedNext X newRest
                    else if operator /= NULL_TOKEN then
                        feedNext operator newRest
                    else if open /= NULL_TOKEN then
                        feedNext open newRest
                    else if close /= NULL_TOKEN then
                        feedNext close newRest
                    else if c == ' ' then
                        feedSpaces newRest
                    else if Char.isDigit c || c == '.' then
                        let
                            (number, pastNumber) = feedNumber c newRest
                        in
                            feedNext number pastNumber
                    else
                        let
                            (func, pastFunc) = feedFunction c newRest
                        in
                            feedNext func pastFunc
            [] -> []
    in
        loop <| String.toList str