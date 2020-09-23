module Constants.Basic exposing (..)

import Types.Shape


wallSideWidth : Int
wallSideWidth =
    64


wallSideHeight : Int
wallSideHeight =
    64


gameView : Types.Shape.Size
gameView =
    { width = 640
    , height = 480
    }
