port module Main exposing (..)

import AnimationFrame
import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Text as Text
import Date
import FontAwesome.Web as Icon
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
        [ h1 [ class "page-heading" ] [ text "Analytics Dashboard" ]
        , Grid.containerFluid []
            [ Grid.row []
                (List.map viewChartContainer model.chartData)
            ]
        ]


viewChartContainer options =
    Grid.col [ Col.md4 ]
        [ Card.config [ Card.outlineWarning, Card.align Text.alignXsCenter ]
            |> Card.header [] [ text <| String.toLower options.id ]
            |> Card.block []
                [ Card.text [ id options.id ] [ viewChart options ]

                --                , Card.text [] [ viewButtonRefresh options ]
                ]
            |> Card.view
        , br [] []
        ]


viewChart options =
    div [ class "chart-placeholder text-primary" ] [ i [ class "fas fa-spinner fa-spin fa-3x" ] [] ]


viewButtonRefresh options =
    Button.button
        [ Button.primary
        , Button.attrs [ class "text-right" ]
        ]
        [ text "Reload ", i [ class "fas fa-sync-alt fa-1x" ] [] ]


type Msg
    = CurrentTick Time.Time
    | None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CurrentTick time ->
            --            let
            ----                x =
            ----                    Debug.log "CurrentTick" <| Date.fromTime time
            --            in
            { model | currentTick = time } ! []

        None ->
            ( model, Cmd.none )



-- Helpers


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


subscriptions =
    \_ -> Sub.none



--AnimationFrame.times CurrentTick
-- PORTS


port renderChart : String -> Cmd msg



-- HELPERS


stubChart index =
    Chart ("chart_" ++ toString index) []


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
    let
        cmds =
            initialModel.chartData |> List.map (\c -> renderChart c.id) |> Cmd.batch
    in
    ( initialModel, cmds )
