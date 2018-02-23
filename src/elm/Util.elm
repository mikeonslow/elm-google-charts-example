module Util
    exposing
        ( (=>)
        , justValues
        , viewIf
        )

import Html exposing (Attribute, Html)
import Html.Events exposing (defaultOptions, on, onWithOptions)
import Json.Decode as Decode


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


{-| infixl 0 means the (=>) operator has the same precedence as (<|) and (|>),
meaning you can use it at the end of a pipeline and have the precedence work out.
-}
infixl 0 =>


viewIf : Bool -> Html msg -> Html msg
viewIf condition content =
    if condition then
        content
    else
        Html.text ""


justValues : List (Maybe a) -> List a
justValues =
    List.filterMap identity
