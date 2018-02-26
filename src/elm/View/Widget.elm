module View.Widget exposing (..)

import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Text as Text
import Data.Widget as Widget
import Html exposing (..)
import Html.Attributes exposing (class, id)


render : Widget.Data -> Grid.Column msg
render options =
    let
        idAsString =
            toString options.id

        widgetId =
            "widget" ++ idAsString
    in
    Grid.col [ Col.md4 ]
        [ Card.config [ Card.outlinePrimary, Card.align Text.alignXsCenter ]
            |> Card.header [] [ text options.label ]
            |> Card.block []
                [ Card.text [ id widgetId ] [ viewChart ] ]
            |> Card.view
        , br [] []
        ]


viewChart : Html msg
viewChart =
    div [ class "chart-placeholder text-primary" ] [ i [ class "fas fa-spinner fa-spin fa-3x" ] [] ]
