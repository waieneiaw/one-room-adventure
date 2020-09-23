module Images.Hole exposing (defs, view)

import Constants.Color
import Svg exposing (Svg)
import Svg.Attributes
import Types.Shape
import Utils.Svg


id : String
id =
    "hole"


view : Types.Shape.Point -> Svg msg
view { x, y } =
    Svg.use
        [ Svg.Attributes.xlinkHref ("#" ++ id)
        , Svg.Attributes.x (String.fromInt x)
        , Svg.Attributes.y (String.fromInt y)
        , Svg.Attributes.fill Constants.Color.backgroundColor
        , Svg.Attributes.stroke Constants.Color.mainColor
        ]
        []


defs : Svg msg
defs =
    Svg.defs []
        [ Svg.g [ Svg.Attributes.id id ]
            [ defImpl
            ]
        ]


size : Types.Shape.Size
size =
    { width = 120
    , height = 120
    }


defImpl : Svg msg
defImpl =
    Utils.Svg.createSvg
        { x = 0, y = 0 }
        size
        []
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width (String.fromInt size.width)
            , Svg.Attributes.height (String.fromInt size.height)
            ]
            []
        , defHole { x = 0, y = 0 }
        ]


defHole : Types.Shape.Point -> Svg msg
defHole point =
    let
        sideSize =
            30

        holeSize =
            { width = size.width - (sideSize * 2)
            , height = size.height - (sideSize * 2)
            }
    in
    Utils.Svg.createSvg
        point
        size
        []
        [ Svg.rect
            [ Svg.Attributes.x (String.fromInt sideSize)
            , Svg.Attributes.y (String.fromInt sideSize)
            , Svg.Attributes.width (String.fromInt holeSize.width)
            , Svg.Attributes.height (String.fromInt holeSize.height)
            ]
            []
        , Svg.line
            [ Svg.Attributes.x1 (String.fromInt 0)
            , Svg.Attributes.y1 (String.fromInt 0)
            , Svg.Attributes.x2 (String.fromInt sideSize)
            , Svg.Attributes.y2 (String.fromInt sideSize)
            ]
            []
        , Svg.line
            [ Svg.Attributes.x1 (String.fromInt 0)
            , Svg.Attributes.y1 (String.fromInt size.height)
            , Svg.Attributes.x2 (String.fromInt sideSize)
            , Svg.Attributes.y2 (String.fromInt (holeSize.height + sideSize))
            ]
            []
        , Svg.line
            [ Svg.Attributes.x1 (String.fromInt size.width)
            , Svg.Attributes.y1 (String.fromInt 0)
            , Svg.Attributes.x2 (String.fromInt (holeSize.width + sideSize))
            , Svg.Attributes.y2 (String.fromInt sideSize)
            ]
            []
        , Svg.line
            [ Svg.Attributes.x1 (String.fromInt size.width)
            , Svg.Attributes.y1 (String.fromInt size.height)
            , Svg.Attributes.x2 (String.fromInt (holeSize.width + sideSize))
            , Svg.Attributes.y2 (String.fromInt (holeSize.height + sideSize))
            ]
            []
        ]
