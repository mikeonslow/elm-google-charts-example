module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, classList, href, src, target, type_, width)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Pipeline exposing (decode, optional, required)


initialModel : Model
initialModel =
    {}


type alias Model =
    {}


view : Model -> Html Msg
view model =
    text "main"


type Msg
    = None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )



-- Helpers


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


subscriptions =
    \_ -> Sub.none


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , update = update
        , init = init
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init  =
    ( initialModel, Cmd.none )
