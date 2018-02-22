module Data.Widget exposing (..)

import Data.Chart as Chart
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, optional, required)


type alias Data =
    { id : Float
    , dashboardId : Float
    , label : String
    }


decoder : Decoder (List Data)
decoder =
    Decode.list
        (decode Data
            |> required "id" Decode.float
            |> required "dashboardId" Decode.float
            |> required "label" Decode.string
        )


endpoint =
    { url = "/api/" }
