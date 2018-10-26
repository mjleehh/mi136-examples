module Render exposing (render)

import Grammar exposing (..)

render : Sum -> String
render sum =
    let
        sumFold : SumOperation -> String -> String
        sumFold val acc = case val of
            POS mult ->
                if acc == "" then
                    acc ++ renderMult mult
                else
                    acc ++ " + " ++ renderMult mult
            NEG mult ->
                if acc == "" then
                    acc ++ "-" ++ renderMult mult
                else
                    acc ++ " - " ++ renderMult mult
    in
        List.foldl sumFold "" sum

renderMult : Mult -> String
renderMult mult =
    let
        multFold : MultOperation -> String -> String
        multFold val acc = case val of
            MUL pow ->
                if acc == "" then
                    renderPow pow
                else
                    acc ++ " * " ++ renderPow pow
            DIV pow -> acc ++ " / " ++ renderPow pow
    in
        List.foldl multFold "" mult

renderPow : Pow -> String
renderPow pow =
    let
        powFold : Func -> String -> String
        powFold func acc =
            if acc == "" then
                renderFunc func
            else
                acc ++ "^" ++ renderFunc func
    in
        List.foldl powFold "" pow

renderFunc : Func -> String
renderFunc func = case func of
    FUNC f arg ->
        let
            argVal = renderAtomic arg
        in
            case f of
                SIN -> "sin " ++ argVal
                COS -> "cos " ++ argVal
                TAN -> "tan " ++ argVal
                LN -> "ln " ++ argVal
                EXP -> "exp " ++ argVal
    ID atomic -> renderAtomic atomic

renderAtomic : AtomicTerm -> String
renderAtomic atomic = case atomic of
    SUM sum -> "(" ++ render sum ++ ")"
    NUM num -> String.fromFloat num
    VAR -> "x"
