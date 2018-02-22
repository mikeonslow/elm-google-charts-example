module Data.Dashboard exposing (..)

import Data.Widget as Widget
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)


type alias Data =
    { id : Float
    , name : String
    , widgets : List Widget.Data
    }


decoder : Decoder Data
decoder =
    decode Data
        |> required "id" Decode.float
        |> required "name" Decode.string
        |> required "widgets" (Decode.list Widget.decoder)
