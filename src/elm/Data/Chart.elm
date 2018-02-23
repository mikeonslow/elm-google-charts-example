module Data.Chart exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, optional, required)
import Json.Encode as Encode exposing (Value)
import Util exposing ((=>))


type alias Data =
    { id : Float, points : List Point }


type alias Points =
    List Point


type alias Point =
    ( String, Float )


decoder : Decoder Data
decoder =
    decode Data
        |> required "id" Decode.float
        |> required "points" (Decode.list <| tuple2Decoder Decode.string Decode.float)


tuple2Decoder : Decoder a -> Decoder b -> Decoder ( a, b )
tuple2Decoder a b =
    Decode.index 0 a
        |> Decode.andThen
            (\a ->
                Decode.index 1 b
                    |> Decode.andThen (\b -> Decode.succeed ( a, b ))
            )


encoder data =
    Encode.object
        [ "id" => Encode.float data.id
        , "points" => encodeData data.points
        ]


encodeData data =
    Encode.list <| encodePoints data


encodePoints points =
    List.map encodePoint points


encodePoint =
    tuple2Encoder Encode.string Encode.float


tuple2Encoder : (a -> Value) -> (b -> Value) -> ( a, b ) -> Value
tuple2Encoder enc1 enc2 ( val1, val2 ) =
    Encode.list [ enc1 val1, enc2 val2 ]
