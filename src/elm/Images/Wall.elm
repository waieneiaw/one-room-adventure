module Images.Wall exposing (defs, view)

import Constants.Color
import Constants.Wall
import Svg exposing (Svg)
import Svg.Attributes


view : Svg msg
view =
    Svg.use
        [ Svg.Attributes.xlinkHref ("#" ++ id)
        , Svg.Attributes.x "0"
        , Svg.Attributes.y "0"
        , Svg.Attributes.stroke Constants.Color.mainColor
        ]
        []


id : String
id =
    "wall"


defs : Svg msg
defs =
    Svg.defs []
        [ Svg.g [ Svg.Attributes.id id ]
            [ defImpl
            ]
        ]


defImpl : Svg msg
defImpl =
    let
        strSideWidth =
            String.fromInt Constants.Wall.sideWidth

        strSideHeight =
            String.fromInt Constants.Wall.sideHeight

        strWidth =
            String.fromInt Constants.Wall.width

        strHeight =
            String.fromInt Constants.Wall.height

        strInnerWidth =
            String.fromInt Constants.Wall.innerWidth

        strInnerHeight =
            String.fromInt Constants.Wall.innerHeight
    in
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.width strWidth
        , Svg.Attributes.height strHeight
        , Svg.Attributes.viewBox ("0 0 " ++ strWidth ++ " " ++ strHeight)
        ]
        [ Svg.rect
            [ Svg.Attributes.x strSideWidth
            , Svg.Attributes.y strSideHeight
            , Svg.Attributes.width strInnerWidth
            , Svg.Attributes.height strInnerHeight
            , Svg.Attributes.strokeWidth "1"
            ]
            []
        , Svg.line
            [ Svg.Attributes.x1 (String.fromInt Constants.Wall.outerTopLeft.x)
            , Svg.Attributes.y1 (String.fromInt Constants.Wall.outerTopLeft.y)
            , Svg.Attributes.x2 (String.fromInt Constants.Wall.innerTopLeft.x)
            , Svg.Attributes.y2 (String.fromInt Constants.Wall.innerTopLeft.y)
            , Svg.Attributes.strokeWidth "1"
            ]
            []
        , Svg.line
            [ Svg.Attributes.x1 (String.fromInt Constants.Wall.outerTopRight.x)
            , Svg.Attributes.y1 (String.fromInt Constants.Wall.outerTopRight.y)
            , Svg.Attributes.x2 (String.fromInt Constants.Wall.innerTopRight.x)
            , Svg.Attributes.y2 (String.fromInt Constants.Wall.innerTopRight.y)
            , Svg.Attributes.strokeWidth "1"
            ]
            []
        , Svg.line
            [ Svg.Attributes.x1 (String.fromInt Constants.Wall.outerBottomLeft.x)
            , Svg.Attributes.y1 (String.fromInt Constants.Wall.outerBottomLeft.y)
            , Svg.Attributes.x2 (String.fromInt Constants.Wall.innerBottomLeft.x)
            , Svg.Attributes.y2 (String.fromInt Constants.Wall.innerBottomLeft.y)
            , Svg.Attributes.strokeWidth "1"
            ]
            []
        , Svg.line
            [ Svg.Attributes.x1 (String.fromInt Constants.Wall.outerBottomRight.x)
            , Svg.Attributes.y1 (String.fromInt Constants.Wall.outerBottomRight.y)
            , Svg.Attributes.x2 (String.fromInt Constants.Wall.innerBottomRight.x)
            , Svg.Attributes.y2 (String.fromInt Constants.Wall.innerBottomRight.y)
            , Svg.Attributes.strokeWidth "1"
            ]
            []
        ]
