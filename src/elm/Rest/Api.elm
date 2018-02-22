module Rest.Api exposing (endpoint)


endpoint =
    { dashboards = url "dashboards"
    , widgets = url "widgets"
    , charts = url "charts"
    }


url s =
    { url = String.join "/" [ root, s ] }


root =
    "api"
