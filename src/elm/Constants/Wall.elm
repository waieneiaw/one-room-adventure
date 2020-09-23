module Constants.Wall exposing (..)

import Constants.Basic
import Types.Shape


size : Types.Shape.Size
size =
    Constants.Basic.gameView


sideSize : Types.Shape.Size
sideSize =
    { width = 64
    , height = 64
    }


outerTopLeft : Types.Shape.Point
outerTopLeft =
    { x = 0, y = 0 }


outerTopRight : Types.Shape.Point
outerTopRight =
    { x = size.width, y = 0 }


outerBottomLeft : Types.Shape.Point
outerBottomLeft =
    { x = 0, y = size.height }


outerBottomRight : Types.Shape.Point
outerBottomRight =
    { x = size.width, y = size.height }


innerSize : Types.Shape.Size
innerSize =
    { width = size.width - (sideSize.width * 2)
    , height = size.height - (sideSize.height * 2)
    }


innerTopLeft : Types.Shape.Point
innerTopLeft =
    { x = outerTopLeft.x + sideSize.width
    , y = outerTopLeft.y + sideSize.height
    }


innerTopRight : Types.Shape.Point
innerTopRight =
    { x = outerTopRight.x - sideSize.width
    , y = outerTopRight.y + sideSize.height
    }


innerBottomLeft : Types.Shape.Point
innerBottomLeft =
    { x = outerBottomLeft.x + sideSize.width
    , y = outerBottomLeft.y - sideSize.height
    }


innerBottomRight : Types.Shape.Point
innerBottomRight =
    { x = outerBottomRight.x - sideSize.width
    , y = outerBottomRight.y - sideSize.height
    }
