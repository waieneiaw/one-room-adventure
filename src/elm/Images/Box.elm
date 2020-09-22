module Images.Box exposing (defs, view)

import Constants.Color
import String exposing (toInt)
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Point
import Utils.Svg


openedId : String
openedId =
    "opened-box"


closedId : String
closedId =
    "closed-box"


view : Types.Object.Openable -> Types.Point.Point -> Svg msg
view obj { x, y } =
    case obj of
        Types.Object.Opened _ ->
            Svg.use
                [ Svg.Attributes.xlinkHref ("#" ++ openedId)
                , Svg.Attributes.x (String.fromInt x)
                , Svg.Attributes.y (String.fromInt y)
                , Svg.Attributes.fill Constants.Color.backgroundColor
                , Svg.Attributes.stroke Constants.Color.mainColor
                ]
                []

        _ ->
            Svg.use
                [ Svg.Attributes.xlinkHref ("#" ++ closedId)
                , Svg.Attributes.x (String.fromInt x)
                , Svg.Attributes.y (String.fromInt y)
                , Svg.Attributes.fill Constants.Color.backgroundColor
                , Svg.Attributes.stroke Constants.Color.mainColor
                ]
                []


sideSize : Int
sideSize =
    20


size : Types.Point.Size
size =
    { width = 170
    , height = 170
    }


surfaceSize : Types.Point.Size
surfaceSize =
    { width = size.width - sideSize
    , height = size.height - sideSize
    }


defs : Svg msg
defs =
    Svg.defs []
        [ Svg.g [ Svg.Attributes.id openedId ]
            [ defOpened
            ]
        , Svg.g [ Svg.Attributes.id closedId ]
            [ defClosed
            ]
        ]


defSurface : Types.Point.Point -> Svg msg
defSurface point =
    let
        doorSize : Types.Point.Size
        doorSize =
            { width = toFloat (surfaceSize.width - 30) / 2 |> floor
            , height = surfaceSize.height - 20
            }
    in
    Utils.Svg.createSvg
        point
        surfaceSize
        []
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width (String.fromInt surfaceSize.width)
            , Svg.Attributes.height (String.fromInt surfaceSize.height)
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x "10"
            , Svg.Attributes.y "10"
            , Svg.Attributes.width (String.fromInt doorSize.width)
            , Svg.Attributes.height (String.fromInt doorSize.height)
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x "80"
            , Svg.Attributes.y "10"
            , Svg.Attributes.width (String.fromInt doorSize.width)
            , Svg.Attributes.height (String.fromInt doorSize.height)
            ]
            []
        , defKeyhole { x = 40, y = 110 }
        ]


defKeyhole : Types.Point.Point -> Svg msg
defKeyhole point =
    let
        size_ : Types.Point.Size
        size_ =
            { width = 24
            , height = 24
            }

        cx =
            toFloat size_.width
                / 2
                |> String.fromFloat

        cy =
            toFloat size_.width
                / 2
                |> String.fromFloat
    in
    Utils.Svg.createSvg
        point
        size_
        []
        [ Svg.circle
            [ Svg.Attributes.cx cx
            , Svg.Attributes.cy cy
            , Svg.Attributes.r "8"
            ]
            []
        , Svg.line
            [ Svg.Attributes.x1 "12"
            , Svg.Attributes.y1 "8"
            , Svg.Attributes.x2 "12"
            , Svg.Attributes.y2 "16"
            ]
            []
        ]


defClosed : Svg msg
defClosed =
    Utils.Svg.createSvg
        { x = 0, y = 0 }
        size
        []
        [ defSide { x = surfaceSize.width, y = 0 }
        , defTop { x = 0, y = 0 }
        , defSurface { x = 0, y = sideSize }
        ]


defOpened : Svg msg
defOpened =
    Utils.Svg.createSvg
        { x = 0, y = 0 }
        size
        []
        [ defSide { x = surfaceSize.width, y = 0 }
        , defSurface { x = 0, y = 20 }
        ]


defSide : Types.Point.Point -> Svg msg
defSide point =
    let
        size_ : Types.Point.Size
        size_ =
            { width = sideSize
            , height = size.height
            }
    in
    Utils.Svg.createSvg
        point
        size_
        []
        [ Svg.polygon
            [ Svg.Attributes.points
                (Utils.Svg.createPolygonLine
                    { x = sideSize, y = 0 }
                    { x = 0, y = sideSize }
                    ++ Utils.Svg.createPolygonLine
                        { x = 0, y = size_.height }
                        { x = sideSize, y = size_.height - sideSize }
                    ++ Utils.Svg.createPolygonLine
                        { x = sideSize, y = size_.height - sideSize }
                        { x = sideSize, y = 0 }
                )
            ]
            []
        ]


defTop : Types.Point.Point -> Svg msg
defTop point =
    let
        size_ : Types.Point.Size
        size_ =
            { width = size.width
            , height = sideSize
            }
    in
    Utils.Svg.createSvg
        point
        size_
        []
        [ Svg.polygon
            [ Svg.Attributes.points
                (Utils.Svg.createPolygonLine
                    { x = sideSize, y = 0 }
                    { x = 0, y = size_.height }
                    ++ Utils.Svg.createPolygonLine
                        { x = 0, y = size_.height }
                        { x = size_.width - sideSize, y = size_.height }
                    ++ Utils.Svg.createPolygonLine
                        { x = size_.width - sideSize, y = size_.height }
                        { x = size_.width, y = 0 }
                )
            ]
            []
        ]
