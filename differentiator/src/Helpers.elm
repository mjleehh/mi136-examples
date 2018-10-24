module Helpers exposing (push)

push : List a -> a -> List a
push list item = List.append list [item]
