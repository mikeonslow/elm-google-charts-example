module Data.Chart exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, optional, required)


type alias Data =
    { id : Float, data : List (List Point) }


type alias Points =
    List Point


type alias Point =
    ( String, Float )


decoder : Decoder Data
decoder =
    decode Data
        |> required "id" Decode.float
        |> required "data" (Decode.list <| Decode.list <| arrayAsTuple2 Decode.string Decode.float)


arrayAsTuple2 : Decoder a -> Decoder b -> Decoder ( a, b )
arrayAsTuple2 a b =
    Decode.index 0 a
        |> Decode.andThen
            (\a ->
                Decode.index 1 b
                    |> Decode.andThen (\b -> Decode.succeed ( a, b ))
            )
