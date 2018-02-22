module Data.Widget exposing (..)

import Data.Chart as Chart
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, optional, required)


type alias Data =
    { id : Float
    , name : String
    , chart : Chart.Data
    }


decoder : Decoder Data
decoder =
    decode Data
        |> required "id" Decode.float
        |> required "name" Decode.string
        |> required "chart" Chart.decoder


endpoint =
    { url = "/api/" }
