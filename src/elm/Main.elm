port module Main exposing (..)

import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Data.Chart as Chart
import Data.Dashboard as Dashboard
import Data.Widget as Widget
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Encode as Encode
import Rest.Api as Api exposing (endpoint)
import View.Widget


-- MODEL


initialState : ( Model, Cmd Msg )
initialState =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg

        model =
            { navbarState = navbarState
            , dashboards = []
            , widgets = []
            , charts = []
            }
    in
    ( model
    , Cmd.batch [ navbarCmd, getDashboards ]
    )


type alias Model =
    { navbarState : Navbar.State
    , dashboards : List Dashboard.Data
    , widgets : List Widget.Data
    , charts : List Chart.Data
    }



-- UPDATE


type Msg
    = NavbarMsg Navbar.State
    | ReceiveDashboards (Result Http.Error (List Dashboard.Data))
    | ReceiveWidgets (Result Http.Error (List Widget.Data))
    | ReceiveChart (Result Http.Error Chart.Data)
    | None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavbarMsg state ->
            ( { model | navbarState = state }, Cmd.none )

        ReceiveDashboards response ->
            let
                successHandler m d =
                    ( { m | dashboards = d }, getWidgets )

                ( updatedModel, cmds ) =
                    response
                        |> handleResponse model successHandler
                        |> Result.withDefault ( model, Cmd.none )
            in
            ( updatedModel, cmds )

        ReceiveWidgets response ->
            let
                successHandler m d =
                    ( { m | widgets = d }
                    , Cmd.batch <|
                        (d
                            |> List.reverse
                            |> List.map (\d -> getChart <| toString d.id)
                        )
                    )

                ( updatedModel, cmds ) =
                    response
                        |> handleResponse model successHandler
                        |> Result.withDefault ( model, Cmd.none )
            in
            ( updatedModel, cmds )

        ReceiveChart response ->
            let
                successHandler m d =
                    ( { m | charts = d :: m.charts }
                    , sendChartData <| Chart.encoder d
                    )

                ( updatedModel, cmds ) =
                    response
                        |> handleResponse model successHandler
                        |> Result.withDefault ( model, Cmd.none )
            in
            ( updatedModel, cmds )

        None ->
            ( model, Cmd.none )


handleResponse : a -> (a -> b -> value) -> Result c b -> Result c value
handleResponse model successHandler response =
    case response of
        Ok data ->
            Ok (successHandler model data)

        Err error ->
            Err error



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


viewNavbar : Model -> Html Msg
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


port sendChartData : Encode.Value -> Cmd msg



-- API


getDashboards : Cmd Msg
getDashboards =
    Http.send ReceiveDashboards (Http.get endpoint.dashboards.url Dashboard.decoder)


getWidgets : Cmd Msg
getWidgets =
    Http.send ReceiveWidgets (Http.get endpoint.widgets.url Widget.decoder)


getChart : String -> Cmd Msg
getChart id =
    let
        url =
            String.join "/" [ endpoint.charts.url, id ]
    in
    Http.send ReceiveChart (Http.get url Chart.decoder)



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
