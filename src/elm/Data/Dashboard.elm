module Data.Dashboard exposing (..)

import Data.Widget as Widget
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)


type alias Data =
    { id : Float
    , label : String
    }


decoder : Decoder (List Data)
decoder =
    Decode.list decodeDashboard


decodeDashboard : Decoder Data
decodeDashboard =
    decode Data
        |> required "id" Decode.float
        |> required "label" Decode.string
