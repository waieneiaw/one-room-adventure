module Images.Rack exposing (defs, view)

import Constants.Color
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Point
import Utils.Svg


id : String
id =
    "rack"


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


size : Types.Point.Size
size =
    { width = 480
    , height = 300
    }


surfaceSize : Types.Point.Size
surfaceSize =
    { width = 150
    , height = 85
    }


defs : Svg msg
defs =
    Svg.defs []
        [ Svg.g [ Svg.Attributes.id id ]
            [ defImpl
            ]
        ]


defImpl : Svg msg
defImpl =
    Utils.Svg.createSvg
        { x = 0, y = 0 }
        size
        []
        [ defSurface { x = 0, y = 0 }
        ]


defSurface : Types.Point.Point -> Svg msg
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
        ]
