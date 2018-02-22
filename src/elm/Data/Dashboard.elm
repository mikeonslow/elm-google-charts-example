module Data.Dashboard exposing (..)

import Data.Widget as Widget


type alias Data =
    { id : Float, name : String, widgets : List Widget.Data }
