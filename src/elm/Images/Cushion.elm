module Images.Cushion exposing (defs, view)

import Constants.Color
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Point


id : String
id =
    "cushion"


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
        , Svg.Attributes.width "110"
        , Svg.Attributes.height "110"
        , Svg.Attributes.viewBox "0 0 110 110"
        ]
        [ Svg.polygon
            [ Svg.Attributes.points
                ("0,0 0,100 "
                    ++ "0,100 10,110 "
                    ++ "10,110 10,10 "
                    ++ "10,10 0,0 "
                )
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.points
                ("0,0 10,10 "
                    ++ "10,10 110,10 "
                    ++ "110,10 100,0 "
                    ++ "100,0 0,0 "
                )
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x "10"
            , Svg.Attributes.y "10"
            , Svg.Attributes.width "100"
            , Svg.Attributes.height "100"

            -- , Svg.Attributes.rx "10"
            -- , Svg.Attributes.ry "10"
            ]
            []
        , Svg.circle
            [ Svg.Attributes.cx "60"
            , Svg.Attributes.cy "60"
            , Svg.Attributes.r "5"
            ]
            []
        ]
