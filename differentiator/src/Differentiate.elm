module Differentiate exposing (differentiate)

import List.Extra exposing (splitWhen)
import Grammar exposing (..)
import Debug exposing (log)

import Render exposing (render)
import Evaluate exposing (evalFunc)

differentiate : Sum -> Sum
differentiate sum = log "d" <|
    let
        diffTerm : SumOperation -> Sum
        diffTerm val = case val of
            POS mult -> diffMult mult
            NEG mult -> diffMult mult
    in
        List.concat <| List.map diffTerm sum

diffMult : Mult -> Sum
diffMult mult =
    let
        removeOperation : MultOperation -> Pow
        removeOperation op = case op of
            MUL term -> term
            DIV term -> term

        addMul : Pow -> MultOperation
        addMul term = MUL term

        loopFactor : List Pow -> Pow -> List MultOperation
        loopFactor list f = case list of
            head :: tail ->
                if head == f then
                    MUL [ID (SUM [diffPow head])] :: loopFactor tail f
                else
                    MUL head :: loopFactor tail f
            [] -> []

        isDiv op = case op of
            DIV _ -> True
            _ -> False
        isMul op = case op of
            MUL _ -> True
            _ -> False

        createFactor : (Mult -> SumOperation) -> Mult -> List Pow -> Pow -> SumOperation
        createFactor sign noDiffs toDiffs elem = sign <| List.append noDiffs <| loopFactor toDiffs elem

        generateSummands sign noDiffs toDiffs = List.map (createFactor sign noDiffs toDiffs) toDiffs

        blankMults = List.map removeOperation <| List.filter isMul mult
        blankDivs = List.map removeOperation <| List.filter isDiv mult

        mults = List.map addMul blankMults
        divs = List.map addMul blankDivs

        multSummands =  generateSummands POS divs blankMults

        -- actually check for divisors to improve result complexity
        res =
            if divs == [] then
                multSummands
            else
                let
                    nominatorSum = List.append multSummands divSummands
                    divSummands = generateSummands NEG mults blankDivs
                    nominator =  MUL [ID (SUM nominatorSum)]
                    denominator = DIV [ID (SUM [POS divs]), ID (NUM 2)]
                in
                    [POS [nominator, denominator]]

    in
        res

{-
    consider a^b with:
    - a ist constant

    (a^b)' = ln a * a^b * b'

    - b is constant
    (a^b)' = b * a^(b-1) * a'

    - a = x, b ist constant
    (x^n) = n x^(n-1)

    - general case:
    (a^b)' = a^b * (ln a b' + b/a a')

-}
diffPow : Pow -> SumOperation
diffPow pow = case pow of
    -- single value cases
    [ID (NUM _)] -> POS [MUL [ID <| NUM 0]]
    [ID VAR] -> POS [MUL [ID <| NUM 1]]
    [FUNC f arg] -> POS [MUL [ID <| SUM <| [diffFunc <| FUNC f arg]]]
    -- special cases
    [ID (SUM sum)] -> POS [MUL [ID <| SUM <| differentiate sum]]
    [ID VAR, ID (NUM n)] ->
        if n /= 0 then
            POS [
                MUL [ID (NUM n)],
                MUL [ID VAR, ID (NUM (n - 1))]
            ]
        else
            POS [MUL [ID (NUM 0)]]

    [ID (NUM a), FUNC b arg] ->
        POS [
            MUL [ID <| NUM <| logBase e a],
            MUL [ID <| NUM a, FUNC b arg],
            MUL [ID <| SUM [diffFunc <| FUNC b arg]]
        ]
    [FUNC a arg, ID (NUM n)] ->
        POS [
            MUL [ID (NUM n)],
            MUL [FUNC a arg, ID <| NUM (n-1)],
            MUL [ID <| SUM [diffFunc <| FUNC a arg]]
        ]
    -- general case
    [a, b] -> generalDiffPower a <| POS [MUL [b]]
    -- general case with more than one exponent level
    a :: rest -> generalDiffPower a <| diffPow rest
    -- shouldn't happen, too lazy to handle in error
    [] -> POS [MUL [ID (NUM 42)]]

generalDiffPower : Func -> SumOperation -> SumOperation
generalDiffPower a b =
    let
        aPowB = MUL [a, ID <| SUM [b]]
        da = diffFunc a
        db = differentiate [b]
        fstSumTerm = [MUL [ID <| SUM db], MUL [FUNC LN <| SUM [da]]]
        sndSumTerm = [MUL [ID <| SUM [da]], MUL [ID <| SUM [b]], DIV [a]]
        sum = [POS fstSumTerm, POS sndSumTerm]
    in
        POS [aPowB, MUL [ID <| SUM sum]]

diffFunc : Func -> SumOperation
diffFunc func = case func of
    FUNC f arg ->
        let
            diffInner = diffAtomic arg
            chainRule sign diffF = sign [MUL [FUNC diffF arg], MUL [ID diffInner]]
        in
            case f of
                SIN -> chainRule POS COS
                COS -> chainRule NEG SIN
                TAN ->
                    let
                        tanSquared g = POS <| [MUL <| [FUNC TAN g, ID g]]
                        num n = POS [MUL [ID (NUM n)]]
                    in
                        POS [MUL [ID (SUM [tanSquared arg, num 1])], MUL [ID diffInner]]
                LN -> POS [MUL [ID diffInner], DIV [ID arg]]
                EXP -> chainRule POS EXP
    ID atomic -> POS [MUL [ID (diffAtomic atomic)]]

diffAtomic : AtomicTerm -> AtomicTerm
diffAtomic atomic = case atomic of
    SUM sum -> SUM <| differentiate sum
    NUM _ -> NUM 0
    VAR -> NUM 1
