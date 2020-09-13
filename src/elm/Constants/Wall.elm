module Constants.Wall exposing (..)

import Constants.Basic
import Types.Point exposing (Point)


width : Int
width =
    Constants.Basic.gameViewWidth


height : Int
height =
    Constants.Basic.gameViewHeight


sideWidth : Int
sideWidth =
    64


sideHeight : Int
sideHeight =
    64


outerTopLeft : Point
outerTopLeft =
    { x = 0, y = 0 }


outerTopRight : Point
outerTopRight =
    { x = width, y = 0 }


outerBottomLeft : Point
outerBottomLeft =
    { x = 0, y = height }


outerBottomRight : Point
outerBottomRight =
    { x = width, y = height }


innerWidth : Int
innerWidth =
    width - (sideWidth * 2)


innerHeight : Int
innerHeight =
    height - (sideHeight * 2)


innerTopLeft : Point
innerTopLeft =
    { x = outerTopLeft.x + sideWidth, y = outerTopLeft.y + sideHeight }


innerTopRight : Point
innerTopRight =
    { x = outerTopRight.x - sideWidth, y = outerTopRight.y + sideHeight }


innerBottomLeft : Point
innerBottomLeft =
    { x = outerBottomLeft.x + sideWidth, y = outerBottomLeft.y - sideHeight }


innerBottomRight : Point
innerBottomRight =
    { x = outerBottomRight.x - sideWidth, y = outerBottomRight.y - sideHeight }
