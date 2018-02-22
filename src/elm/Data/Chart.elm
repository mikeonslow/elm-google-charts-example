module Data.Chart exposing (..)


type alias Data =
    { id : Float, data : List Point }


type alias Point =
    ( String, Float )
