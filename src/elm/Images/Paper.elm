module Images.Paper exposing (defs, view)

import Constants.Color
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Point
import Utils.Svg


id : String
id =
    "paper"


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
    { width = 40
    , height = 20
    }


depth : Int
depth =
    6


defImpl : Svg msg
defImpl =
    Utils.Svg.createSvg
        { x = 0, y = 0 }
        size
        []
        [ Svg.polygon
            [ Svg.Attributes.points
                (Utils.Svg.createPolygonLine
                    { x = depth, y = 0 }
                    { x = 0, y = size.height }
                    ++ Utils.Svg.createPolygonLine
                        { x = 0, y = size.height }
                        { x = size.width, y = size.height }
                    ++ Utils.Svg.createPolygonLine
                        { x = size.width, y = size.height }
                        { x = size.width - depth, y = 0 }
                )
            ]
            []
        ]
