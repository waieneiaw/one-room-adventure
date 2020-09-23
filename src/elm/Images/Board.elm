module Images.Board exposing (defs, view)

import Constants.Color
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Point
import Utils.Svg


id : String
id =
    "board"


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
        , defScrew { x = 5, y = 5 }
        , defScrew { x = 105, y = 5 }
        , defScrew { x = 5, y = 105 }
        , defScrew { x = 105, y = 105 }
        ]


defScrew : Types.Point.Point -> Svg msg
defScrew point =
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.x (String.fromInt point.x)
        , Svg.Attributes.y (String.fromInt point.y)
        ]
        [ Svg.circle
            [ Svg.Attributes.cx "6"
            , Svg.Attributes.cy "6"
            , Svg.Attributes.r "3"
            ]
            []
        ]
