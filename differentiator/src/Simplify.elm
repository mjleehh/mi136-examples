module Simplify  exposing (simplify)

import Grammar exposing (..)
import Debug exposing (log)

sumZeroTerm = [MUL [ID <| NUM 0]]
multOneTerm = [ID <| NUM 1]
multZeroTerm = [ID <| NUM 0]

simplify : Sum -> Sum
simplify sum =
    let
        applyNumberTerms terms =
            let
                isNotANumber term = case term of
                    POS [MUL [ID (NUM _)]] -> False
                    NEG [MUL [ID (NUM _)]] -> False
                    _ -> True

                applyTerm term acc = case term of
                    POS [MUL [ID (NUM n)]] -> acc + n
                    NEG [MUL [ID (NUM n)]] -> acc - n
                    _ -> acc

                nonNumbers = List.filter isNotANumber terms
                value = List.foldl applyTerm 0 terms
                appliedNumbers =
                    if value < 0 then
                        NEG [MUL [ID <| NUM <| abs value]]
                    else
                        POS [MUL [ID <| NUM <| value]]
            in
                appliedNumbers :: nonNumbers

        invertSigns term = case term of
            POS mult -> NEG mult
            NEG mult -> POS mult

        removeUselessBlocks term = case term of
            POS [MUL [ID (SUM subSum)]] -> subSum
            NEG [MUL [ID (SUM subSum)]] -> List.map invertSigns subSum
            POS mult -> [POS mult]
            NEG mult -> [NEG mult]

        simplifyTerm term = case term of
            POS mult -> POS <| simplifyMult mult
            NEG mult -> NEG <| simplifyMult mult

        isNonZero term =
            if term == POS sumZeroTerm then
                False
            else if term == NEG sumZeroTerm then
                False
            else if term == POS [] || term == NEG [] then
                False
            else
                True

        replaceEmptyWithZero list =
            if list == [] then
                [POS [MUL [ID <| NUM 0]]]
            else
                list
    in
        replaceEmptyWithZero
        <| List.filter isNonZero
        <| applyNumberTerms
        <| List.concatMap removeUselessBlocks
        <| List.map simplifyTerm sum

simplifyMult : Mult -> Mult
simplifyMult mult =
    let
        applyNumberTerms terms =
            let
                isNotANumber term = case term of
                    MUL [ID (NUM _)] -> False
                    DIV [ID (NUM _)] -> False
                    _ -> True

                applyTerm term acc = case term of
                    MUL [ID (NUM n)] -> acc * n
                    DIV [ID (NUM n)] -> acc / n
                    _ -> acc

                nonNumbers = List.filter isNotANumber terms
                value = List.foldl applyTerm 1 terms
                appliedNumbers = MUL [ID <| NUM <| value ]
            in
                appliedNumbers :: nonNumbers

        removeUselessBlocks term =
            let
               invertMults subTerm = case subTerm of
                   MUL pow -> DIV pow
                   DIV pow -> MUL pow
            in
                case term of
                    MUL [ID (SUM [POS subMul])] -> subMul
                    DIV [ID (SUM [POS subMul])] -> List.map invertMults subMul
                    MUL pow -> [MUL pow]
                    DIV pow -> [DIV pow]

        isNonOne term =
            if term == MUL multOneTerm then
                False
            else if term == DIV multOneTerm then
                False
            else
                True

        isZero term =
            if term == MUL multZeroTerm then
                True
            else if term == DIV multZeroTerm then
                True
            else if term == MUL [] || term == DIV [] then
                True
            else
                False

        simplyfyTerm term = case term of
            MUL pow -> MUL <| simplifyPow pow
            DIV pow -> DIV <| simplifyPow pow

        replaceEmtpyWithOne list =
            if list == [] then
                [MUL [ID <| NUM 1]]
            else
                list

        zeroIfContainsZero list =
            if List.any isZero list then
                [MUL multZeroTerm]
            else
                list
    in
        replaceEmtpyWithOne
        <| applyNumberTerms
        <| zeroIfContainsZero
        <| List.filter isNonOne
        <| List.concatMap removeUselessBlocks
        <| List.map simplyfyTerm mult


simplifyPow : Pow -> Pow
simplifyPow pow =
    let
        simplfyTerm term = simplifyFunc term
    in
        List.map simplfyTerm pow

simplifyFunc : Func -> Func
simplifyFunc func = case func of
    ID atomic -> ID <| simplifyAtomic atomic
    _ -> func

simplifyAtomic : AtomicTerm -> AtomicTerm
simplifyAtomic atomic = case atomic of
    SUM sum -> SUM <| simplify sum
    NUM num -> NUM num
    VAR -> VAR
