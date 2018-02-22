module Data.Widget exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, optional, required)


type alias Data =
    { id : Float
    , name : String
    , chart : Int
    }


decoder : Decoder Data
decoder =
    decode Data
        |> required "id" Decode.float
        |> required "name" Decode.string
        |> optional "charts" Decode.int 999
