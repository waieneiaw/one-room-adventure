module Images.Screwdriver exposing (defs, view)

import Constants.Color
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Point
import Utils.Svg


id : String
id =
    "screwdriver"


view : Types.Object.Plain -> Types.Point.Point -> Svg msg
view obj { x, y } =
    if obj.status == Types.Object.Exist then
        Svg.use
            [ Svg.Attributes.xlinkHref ("#" ++ id)
            , Svg.Attributes.x (String.fromInt x)
            , Svg.Attributes.y (String.fromInt y)
            , Svg.Attributes.fill Constants.Color.backgroundColor
            , Svg.Attributes.stroke Constants.Color.mainColor
            ]
            []

    else
        Svg.svg [ Svg.Attributes.id id ] []


defs : Svg msg
defs =
    Svg.defs []
        [ Svg.g [ Svg.Attributes.id id ]
            [ defImpl
            ]
        ]


size : Types.Point.Size
size =
    { width = 90
    , height = 10
    }


defImpl : Svg msg
defImpl =
    let
        handle =
            { width = 35
            , height = 10
            }
    in
    Utils.Svg.createSvg
        { x = 0, y = 0 }
        size
        []
        [ Svg.rect
            [ Svg.Attributes.x (String.fromInt (handle.width - 5))
            , Svg.Attributes.y "4"
            , Svg.Attributes.width (String.fromInt (size.width - handle.width - 5))
            , Svg.Attributes.height "2"
            , Svg.Attributes.rx "5"
            , Svg.Attributes.ry "5"
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width (String.fromInt handle.width)
            , Svg.Attributes.height (String.fromInt handle.height)
            , Svg.Attributes.rx "3"
            , Svg.Attributes.ry "3"
            ]
            []
        , Svg.line
            [ Svg.Attributes.x1 "0"
            , Svg.Attributes.y1 "2"
            , Svg.Attributes.x2 (String.fromInt handle.width)
            , Svg.Attributes.y2 "2"
            ]
            []
        , Svg.line
            [ Svg.Attributes.x1 "0"
            , Svg.Attributes.y1 "7"
            , Svg.Attributes.x2 (String.fromInt handle.width)
            , Svg.Attributes.y2 "7"
            ]
            []
        ]
