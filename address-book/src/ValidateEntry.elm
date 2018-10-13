module ValidateEntry exposing (validateEntry, renderValidationErrors)

import Regex exposing (Regex)
import Html exposing (Html, text)

import State exposing (Entry)
import Action exposing (Action)
import Validate exposing (Validator, ifBlank, ifInvalidEmail, fromErrors)

validPhoneNumber : Regex
validPhoneNumber =
    "^\\+?(\\s*[0-9]+)+$"
        |> Regex.fromStringWith { caseInsensitive = True, multiline = False }
        |> Maybe.withDefault Regex.never

isValidPhoneNumber phoneNumber =
    Regex.contains validPhoneNumber phoneNumber

ifInvalidPhoneNumber : (subject -> Maybe String) -> error -> Validator error subject
ifInvalidPhoneNumber subjectToMaybeString error =
    let
        getErrors subject =
            case subjectToMaybeString subject of
                Just str -> if isValidPhoneNumber str
                    then []
                    else [error]
                Nothing -> []
    in
        fromErrors getErrors




validateEntry : Validator String Entry
validateEntry = Validate.firstError [
        ifBlank .name "you have to specify a name",
        ifBlank .email "you have to specify an email",
        ifInvalidEmail .email (\email -> "email " ++ email ++ " is invalid"),
        ifInvalidPhoneNumber .phone "the phone number you have entered is invalid"
    ]

renderValidationErrors : List String -> List (Html Action)
renderValidationErrors validationErrors =
    List.map (\elem -> text elem) validationErrors