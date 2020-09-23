module Images.LowerDrawer exposing (defs, view)

import Constants.Color
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Shape
import Utils.Svg


openedId : String
openedId =
    "opened-lower-drawer"


closedId : String
closedId =
    "closed-lower-drawer"


view : Types.Object.Openable -> Types.Shape.Point -> Svg msg
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


size : Types.Shape.Size
size =
    { width = 180
    , height = 105
    }


surfaceSize : Types.Shape.Size
surfaceSize =
    { width = 150
    , height = 85
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


defSurface : Types.Shape.Point -> Svg msg
defSurface point =
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
            [ Svg.Attributes.x "50"
            , Svg.Attributes.y "20"
            , Svg.Attributes.width "50"
            , Svg.Attributes.height "10"
            ]
            []
        , defKeyhole { x = 12, y = 12 }
        ]


defKeyhole : Types.Shape.Point -> Svg msg
defKeyhole point =
    let
        size_ : Types.Shape.Size
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
        surfaceSize
        []
        [ defSurface { x = 0, y = 0 }
        ]


defOpened : Svg msg
defOpened =
    Utils.Svg.createSvg
        { x = 0, y = 0 }
        size
        []
        [ defSide { x = 0, y = 0 }
        , defSide { x = 150, y = 0 }
        , defSurface { x = 20, y = 20 }
        ]


defSide : Types.Shape.Point -> Svg msg
defSide point =
    let
        size_ : Types.Shape.Size
        size_ =
            { width = 20
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
                    { x = 0, y = 0 }
                    { x = 0, y = size_.height - 20 }
                    ++ Utils.Svg.createPolygonLine
                        { x = 0, y = size_.height - 20 }
                        { x = 20, y = size_.height }
                    ++ Utils.Svg.createPolygonLine
                        { x = 20, y = size_.height }
                        { x = 20, y = 20 }
                )
            ]
            []
        ]
