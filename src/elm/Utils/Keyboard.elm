module Utils.Keyboard exposing (onKeyDown)

import Html exposing (Attribute)
import Html.Events exposing (keyCode, on)
import Json.Decode as D


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown msg =
    on "keydown" (D.map msg keyCode)
