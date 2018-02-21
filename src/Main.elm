module Main exposing (..)

import AnimationFrame
import Date
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Pipeline exposing (decode, optional, required)
import Time


initialModel : Model
initialModel =
    let
        charts =
            List.range 1 22 |> List.map (\i -> stubChart i)
    in
    { chartData = charts, currentTick = 0 }


type alias Model =
    { chartData : List Chart, currentTick : Float }


type alias Chart =
    { id : String, data : List Int }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Analytics Dashboard\n        " ]
        , div [ class "dashboard-container" ] (List.map viewChartContainer model.chartData)
        ]


viewChartContainer options =
    div [ id options.id, class "chart-container" ]
        [ viewChart options
        , text options.id
        , button [] [ text "Reload" ]
        ]


viewChart options =
    div [ class "chart" ] [ i [ class "fas fa-chart-pie fa-8x" ] [] ]


type Msg
    = CurrentTick Time.Time
    | None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CurrentTick time ->
            let
                x =
                    Debug.log "CurrentTick" <| Date.fromTime time
            in
            { model | currentTick = time } ! []

        None ->
            ( model, Cmd.none )



-- Helpers


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


subscriptions =
    \_ -> AnimationFrame.times CurrentTick



--HELPERS


stubChart index =
    Chart ("chart " ++ toString index) []


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , update = update
        , init = init
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )
