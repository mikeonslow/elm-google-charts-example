port module Main exposing (..)

import AnimationFrame
import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Navbar as Navbar
import Bootstrap.Text as Text
import Data.Chart as Chart
import Data.Dashboard as Dashboard
import Data.Widget as Widget
import Date
import FontAwesome.Web as Icon
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Pipeline exposing (decode, optional, required)
import Rest.Api as Api exposing (endpoint)
import Time
import View.Widget


-- MODEL


initialState : ( Model, Cmd Msg )
initialState =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg

        --        chartCmds =
        --            charts |> List.reverse |> List.map (\c -> renderChart c.id)
        model =
            { navbarState = navbarState
            , dashboards = []
            , widgets = []
            , charts = []
            , currentTick = 0
            }
    in
    ( model
    , Cmd.batch [ navbarCmd, getDashboards, getWidgets ]
    )


type alias Model =
    { navbarState : Navbar.State
    , dashboards : List Dashboard.Data
    , widgets : List Widget.Data
    , charts : List Chart.Data
    , currentTick : Float
    }


type alias Chart =
    { id : String, data : List Int }



-- UPDATE


type Msg
    = NavbarMsg Navbar.State
    | CurrentTick Time.Time
    | ReceiveDashboards (Result Http.Error (List Dashboard.Data))
    | ReceiveWidgets (Result Http.Error (List Widget.Data))
    | ReceiveCharts (Result Http.Error (List Chart.Data))
    | None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavbarMsg state ->
            ( { model | navbarState = state }, Cmd.none )

        ReceiveDashboards response ->
            case response of
                Ok response ->
                    let
                        updatedModel =
                            { model | dashboards = response }
                    in
                    ( updatedModel, Cmd.none )

                Err error ->
                    let
                        errorMessage =
                            "An error occurred: " ++ toString error

                        x =
                            Debug.log "errorMessage" errorMessage
                    in
                    ( model, Cmd.none )

        ReceiveWidgets response ->
            case response of
                Ok response ->
                    let
                        updatedModel =
                            { model | widgets = response }
                    in
                    ( updatedModel, Cmd.none )

                Err error ->
                    let
                        errorMessage =
                            "An error occurred: " ++ toString error

                        x =
                            Debug.log "errorMessage" errorMessage
                    in
                    ( model, Cmd.none )

        ReceiveCharts response ->
            case response of
                Ok response ->
                    let
                        updatedModel =
                            { model | charts = response }
                    in
                    ( updatedModel, Cmd.none )

                Err error ->
                    let
                        errorMessage =
                            "An error occurred: " ++ toString error

                        x =
                            Debug.log "errorMessage" errorMessage
                    in
                    ( model, Cmd.none )

        CurrentTick time ->
            --            let
            ----                x =
            ----                    Debug.log "CurrentTick" <| Date.fromTime time
            --            in
            { model | currentTick = time } ! []

        None ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewNavbar model
        , br [] []
        , Grid.containerFluid []
            [ Grid.row []
                (List.map View.Widget.render model.widgets)
            ]
        ]


viewNavbar model =
    Navbar.config NavbarMsg
        |> Navbar.withAnimation
        |> Navbar.brand [ href "#" ] [ i [ class "fas fa-chart-bar" ] [], text " Elm + Google Charts Example" ]
        |> Navbar.info
        |> Navbar.items
            []
        |> Navbar.view model.navbarState



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navbarState NavbarMsg



-- PORTS


port renderChart : String -> Cmd msg



-- API


getDashboards : Cmd Msg
getDashboards =
    Http.send ReceiveDashboards (Http.get endpoint.dashboards.url Dashboard.decoder)


getWidgets : Cmd Msg
getWidgets =
    Http.send ReceiveWidgets (Http.get endpoint.widgets.url Widget.decoder)



-- HELPERS


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


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
        ( initialModel, initialCmds ) =
            initialState
    in
    ( initialModel, initialCmds )
