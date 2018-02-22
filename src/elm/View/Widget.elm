module View.Widget exposing (..)

import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Text as Text
import Html exposing (br, div, i, text)
import Html.Attributes exposing (class, id)


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
                [ Card.text [ id widgetId ] [ viewChart options ]

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
