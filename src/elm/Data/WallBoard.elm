module Data.WallBoard exposing (..)

import Data.Dashboard as Dashboard
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)


type alias Data =
    { dashboards : List Dashboard.Data }


initialModel : Data
initialModel =
    { dashboards = [] }


decoder : Decoder Data
decoder =
    decode Data
        |> required "dashboards" (Decode.list Dashboard.decoder)
