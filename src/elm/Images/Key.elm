module Images.Key exposing (defs, view)

import Constants.Color
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Point


id : String
id =
    "key"


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


defImpl : Svg msg
defImpl =
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.width "32"
        , Svg.Attributes.height "32"
        , Svg.Attributes.viewBox "0 0 32 32"
        ]
        [ Svg.rect
            [ Svg.Attributes.x "4"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width "20"
            , Svg.Attributes.height "10"
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x "10"
            , Svg.Attributes.y "4"
            , Svg.Attributes.width "8"
            , Svg.Attributes.height "2"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.points
                "10,10 10,26 14,32 18,26 18,10"
            ]
            []
        , Svg.line
            [ Svg.Attributes.x1 "14"
            , Svg.Attributes.y1 "14"
            , Svg.Attributes.x2 "14"
            , Svg.Attributes.y2 "30"
            ]
            []
        ]
