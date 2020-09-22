module Images.Sofa exposing (defs, view)

import Constants.Color
import Constants.Wall
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Point


id : String
id =
    "sofa"


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
    let
        strWidth =
            String.fromInt Constants.Wall.width

        strHeight =
            String.fromInt 400
    in
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.width strWidth
        , Svg.Attributes.height strHeight
        , Svg.Attributes.viewBox ("0 0 " ++ strWidth ++ " " ++ strHeight)
        ]
        [ defLeg { x = 80, y = 220 }
        , defLeg { x = 550, y = 220 }
        , defSeat { x = 32, y = 170 }
        , defBackrest { x = 80, y = 40 }
        , defLeftArmrest { x = 40, y = 130 }
        , defRightArmrest { x = 540, y = 130 }
        ]


defBackrest : Types.Point.Point -> Svg msg
defBackrest point =
    let
        strBackrestWidth =
            String.fromInt (Constants.Wall.innerWidth - 32)

        strBackrestHeight =
            String.fromInt 130
    in
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.x (String.fromInt point.x)
        , Svg.Attributes.y (String.fromInt point.y)
        , Svg.Attributes.width strBackrestWidth
        , Svg.Attributes.height strBackrestHeight
        , Svg.Attributes.viewBox
            ("0 0 "
                ++ strBackrestWidth
                ++ " "
                ++ strBackrestHeight
            )
        ]
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width strBackrestWidth
            , Svg.Attributes.height strBackrestHeight
            ]
            []
        ]


defLeftArmrest : Types.Point.Point -> Svg msg
defLeftArmrest point =
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.x (String.fromInt point.x)
        , Svg.Attributes.y (String.fromInt point.y)
        , Svg.Attributes.width "64"
        , Svg.Attributes.height "100"
        , Svg.Attributes.viewBox "0 0 64 100"
        ]
        [ Svg.polygon
            [ Svg.Attributes.points
                ("32,0 0,20 "
                    ++ "0,20 32,20 "
                    ++ "32,20 64,0 "
                    ++ "32,0 64,0 "
                )
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "20"
            , Svg.Attributes.width "32"
            , Svg.Attributes.height "10"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.points
                ("32,0 0,20 "
                    ++ "0,20 32,20 "
                    ++ "32,20 64,0 "
                    ++ "32,0 64,0 "
                )
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.points
                ("32,30 64,10 "
                    ++ "64,0 32,20 "
                )
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x "16"
            , Svg.Attributes.y "30"
            , Svg.Attributes.width "8"
            , Svg.Attributes.height "40"
            ]
            []
        ]


defRightArmrest : Types.Point.Point -> Svg msg
defRightArmrest point =
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.x (String.fromInt point.x)
        , Svg.Attributes.y (String.fromInt point.y)
        , Svg.Attributes.width "64"
        , Svg.Attributes.height "100"
        , Svg.Attributes.viewBox "0 0 64 100"
        ]
        [ Svg.polygon
            [ Svg.Attributes.points
                ("32,0 64,20 "
                    ++ "64,20 32,20 "
                    ++ "32,20 0,0 "
                    ++ "32,0 0,0 "
                )
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x "32"
            , Svg.Attributes.y "20"
            , Svg.Attributes.width "32"
            , Svg.Attributes.height "10"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.points
                ("32,0 64,20 "
                    ++ "64,20 32,20 "
                    ++ "32,20 0,0 "
                    ++ "32,0 0,0 "
                )
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.points
                ("32,30 0,10 "
                    ++ "0,0 32,20 "
                )
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x "40"
            , Svg.Attributes.y "30"
            , Svg.Attributes.width "8"
            , Svg.Attributes.height "40"
            ]
            []
        ]


defSeat : Types.Point.Point -> Svg msg
defSeat point =
    let
        strBackrestWidth =
            String.fromInt (Constants.Wall.innerWidth + 64)

        strBackrestHeight =
            String.fromInt 60
    in
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.x (String.fromInt point.x)
        , Svg.Attributes.y (String.fromInt point.y)
        , Svg.Attributes.width strBackrestWidth
        , Svg.Attributes.height strBackrestHeight
        , Svg.Attributes.viewBox
            ("0 0 "
                ++ strBackrestWidth
                ++ " "
                ++ strBackrestHeight
            )
        ]
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "30"
            , Svg.Attributes.width strBackrestWidth
            , Svg.Attributes.height "30"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.points
                ("32,0 0,30 "
                    ++ "0,30 600,30 "
                    ++ "578,30 544,0 "
                    ++ "546,0 32,0 "
                 -- ++ "32,0 64,0 "
                )
            ]
            []
        ]


defLeg : Types.Point.Point -> Svg msg
defLeg point =
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.x (String.fromInt point.x)
        , Svg.Attributes.y (String.fromInt point.y)
        , Svg.Attributes.width "8"
        , Svg.Attributes.height "40"
        , Svg.Attributes.viewBox "0 0 8 40"
        ]
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width "8"
            , Svg.Attributes.height "40"
            ]
            []
        ]
