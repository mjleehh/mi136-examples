module Grammar exposing (..)

type Function =
    SIN
    | COS
    | TAN
    | LN
    | EXP

type alias Sum = List SumOperation
type SumOperation = POS Mult | NEG Mult

type alias Mult = List MultOperation
type MultOperation = FIRST_MULT Pow | MUL Pow | DIV Pow

type alias Pow = List PowOperation
type PowOperation = FIRST_POW Func | POW Func

type  Func = ID AtomicTerm | FUNC Function AtomicTerm

type AtomicTerm = SUM Sum | NUM Float | VAR