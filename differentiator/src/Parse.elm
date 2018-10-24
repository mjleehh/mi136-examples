module Parse exposing (..)

import Grammar exposing (..)
import Tokenize exposing (Token(..), Operator(..))
import Blockify exposing (Block(..))
import Helpers exposing (push)


parse : List Block -> Result String Sum
parse expList =
    let
        emptyTerms : List Block
        emptyTerms = []

        -- first term in block does note require (+/-)
        startSum : List Block -> Result String Sum
        startSum rest = case rest of
            (exp :: newRest) -> case exp of
                NONBLOCK (OPERATOR PLUS) -> feedTerms emptyTerms POS newRest
                NONBLOCK (OPERATOR MINUS) -> feedTerms emptyTerms NEG newRest
                _ -> feedTerms emptyTerms POS rest
            [] -> Err "empty sum"

        -- every following
        feedTerms : List Block -> (Mult -> SumOperation) -> List Block -> Result String Sum
        feedTerms acc operation rest = case rest of
            (exp :: newRest) -> case exp of
                NONBLOCK (OPERATOR PLUS) -> case feedTerms emptyTerms POS newRest of
                    Ok afterTerm -> case parseMult acc of
                        Ok mult -> Ok (operation mult :: afterTerm)
                        Err err -> Err err
                    Err err -> Err err
                NONBLOCK (OPERATOR MINUS) -> case feedTerms emptyTerms NEG newRest of
                    Ok afterTerm -> case parseMult acc of
                        Ok mult -> Ok (operation mult :: afterTerm)
                        Err err -> Err err
                    Err err -> Err err
                _ -> feedTerms (push acc exp) operation newRest
            [] -> case parseMult acc of
                Ok mult -> Ok [operation mult]
                Err err -> Err err
        in
            startSum expList

parseMult : List Block -> Result String Mult
parseMult expList =
    let
        emptyTerms : List Block
        emptyTerms = []

        -- first term in block does note require (+/-)
        startMult : List Block -> Result String Mult
        startMult rest = case rest of
            (exp :: newRest) -> case exp of
                NONBLOCK (OPERATOR TIMES) -> Err "leading multiplication symbol"
                NONBLOCK (OPERATOR DIVISION) -> Err "leading division symbol"
                _ -> feedTerms emptyTerms FIRST_MULT rest
            [] -> Err "empty sum"

        -- every following
        feedTerms : List Block -> (Pow -> MultOperation) -> List Block -> Result String Mult
        feedTerms acc operation rest = case rest of
            (exp :: newRest) -> case exp of
                NONBLOCK (OPERATOR TIMES) -> case feedTerms emptyTerms MUL newRest of
                    Ok afterTerm -> case parsePow acc of
                        Ok pow -> Ok (operation pow :: afterTerm)
                        Err err -> Err err
                    Err err -> Err err
                NONBLOCK (OPERATOR DIVISION) -> case feedTerms emptyTerms DIV newRest of
                    Ok afterTerm -> case parsePow acc of
                        Ok pow -> Ok (operation pow :: afterTerm)
                        Err err -> Err err
                    Err err -> Err err
                _ -> feedTerms (push acc exp) operation newRest
            [] -> case parsePow acc of
                Ok pow -> Ok [operation pow]
                Err err -> Err err
    in
        startMult expList

parsePow : List Block -> Result String Pow
parsePow expList =
    let
        emptyTerms : List Block
        emptyTerms = []

        -- first term in block does note require (+/-)
        startMult : List Block -> Result String Pow
        startMult rest = case rest of
            (exp :: newRest) -> case exp of
                NONBLOCK (OPERATOR POWER) -> Err "leading multiplication symbol"
                _ -> feedTerms emptyTerms FIRST_POW rest
            [] -> Err "empty sum"

        -- every following
        feedTerms : List Block -> (Func -> PowOperation) -> List Block -> Result String Pow
        feedTerms acc operation rest = case rest of
            (exp :: newRest) -> case exp of
                NONBLOCK (OPERATOR POWER) -> case feedTerms emptyTerms POW newRest of
                    Ok afterTerm -> case parseFunc acc of
                        Ok func -> Ok (operation func :: afterTerm)
                        Err err -> Err err
                    Err err -> Err err
                _ -> feedTerms (push acc exp) operation newRest
            [] -> case parseFunc acc of
                Ok func -> Ok [operation func]
                Err err -> Err err
    in
        startMult expList

parseFunc : List Block -> Result String Func
parseFunc expList = case expList of
    (exp :: []) -> case parseAtomic expList of
        Ok atomic -> Ok (ID atomic)
        Err err -> Err err
    (NONBLOCK (FUNCTION f) :: rest) -> case parseAtomic rest of
        Ok atomic -> Ok (FUNC f atomic)
        Err err -> Err err
    _ -> Err "not a valid function"

parseAtomic : List Block -> Result String AtomicTerm
parseAtomic expList = case expList of
    NONBLOCK X :: [] -> Ok VAR
    NONBLOCK (NUMBER num) :: [] -> Ok (NUM num)
    BLOCK block :: [] -> case parse block of
        Ok sum -> Ok (SUM sum)
        Err err -> Err err
    _ -> Err "invalid atomic"