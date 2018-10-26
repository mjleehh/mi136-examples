module Evaluate exposing (evaluate)

import Grammar exposing (..)

evaluate : Float -> Sum -> Float
evaluate x sum =
    let
        sumFold : SumOperation -> Float -> Float
        sumFold val acc = case val of
            POS mult -> acc + evalMult x mult
            NEG mult -> acc - evalMult x mult
    in
        List.foldl sumFold 0 sum

evalMult : Float -> Mult -> Float
evalMult x mult =
    let
        multFold : MultOperation -> Float -> Float
        multFold val acc = case val of
            MUL pow -> acc * evalPow x pow
            DIV pow -> acc / evalPow x pow
    in
        List.foldl multFold 1 mult

evalPow : Float -> Pow -> Float
evalPow x pow =
    let
        powFold : Func -> Float -> Float
        powFold func acc = (evalFunc x func)^acc
    in
        List.foldr powFold 1 pow

evalFunc : Float -> Func -> Float
evalFunc x func = case func of
    FUNC f arg ->
        let
            argVal = evalAtomic x arg
        in
            case f of
                SIN -> sin argVal
                COS -> cos argVal
                TAN -> tan argVal
                LN -> logBase e argVal
                EXP -> e^argVal
    ID atomic -> evalAtomic x atomic

evalAtomic : Float -> AtomicTerm -> Float
evalAtomic x atomic = case atomic of
    SUM sum -> evaluate x sum
    NUM num -> num
    VAR -> x