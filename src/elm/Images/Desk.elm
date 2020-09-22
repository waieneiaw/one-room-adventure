module Images.Desk exposing (defs, view)

import Constants.Color
import Constants.Wall
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Point


id : String
id =
    "desk"


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
            String.fromInt 300
    in
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.width strWidth
        , Svg.Attributes.height strHeight
        , Svg.Attributes.viewBox ("0 0 " ++ strWidth ++ " " ++ strHeight)
        ]
        [ defLeftLeg { x = 50, y = 0 }
        , defRightLeg { x = 500, y = 0 }
        , defCabinet { x = 330, y = 60 }
        , defSurface { x = 0, y = 0 }
        ]


defSurface : Types.Point.Point -> Svg msg
defSurface point =
    let
        strWidth =
            String.fromInt (Constants.Wall.innerWidth + 64)

        strHeight =
            String.fromInt 60
    in
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.x (String.fromInt point.x)
        , Svg.Attributes.y (String.fromInt point.y)
        , Svg.Attributes.width strWidth
        , Svg.Attributes.height strHeight
        , Svg.Attributes.viewBox
            ("0 0 "
                ++ strWidth
                ++ " "
                ++ strHeight
            )
        ]
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "30"
            , Svg.Attributes.width strWidth
            , Svg.Attributes.height "30"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.points
                ("32,0 0,30 "
                    ++ "0,30 600,30 "
                    ++ "578,30 544,0 "
                    ++ "546,0 32,0 "
                )
            ]
            []
        ]


defLeftLeg : Types.Point.Point -> Svg msg
defLeftLeg point =
    let
        width =
            "60"

        legWidth =
            "30"

        height =
            "230"
    in
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.x (String.fromInt point.x)
        , Svg.Attributes.y (String.fromInt point.y)
        , Svg.Attributes.width width
        , Svg.Attributes.height height
        , Svg.Attributes.viewBox
            ("0 0"
                ++ " "
                ++ width
                ++ " "
                ++ height
            )
        ]
        [ Svg.polygon
            [ Svg.Attributes.points
                ("30,0 30,230 "
                    ++ "30,230 60,190 "
                    ++ "60,190 60,0 "
                )
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width legWidth
            , Svg.Attributes.height height
            ]
            []
        ]


defRightLeg : Types.Point.Point -> Svg msg
defRightLeg point =
    let
        width =
            "30"

        height =
            "230"
    in
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.x (String.fromInt point.x)
        , Svg.Attributes.y (String.fromInt point.y)
        , Svg.Attributes.width width
        , Svg.Attributes.height height
        , Svg.Attributes.viewBox
            ("0 0"
                ++ " "
                ++ width
                ++ " "
                ++ height
            )
        ]
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width width
            , Svg.Attributes.height height
            ]
            []
        ]


defCabinet : Types.Point.Point -> Svg msg
defCabinet point =
    let
        width =
            "170"

        surfaceWidth =
            "150"

        surfaceX =
            "20"

        height =
            "170"

        drawerHeight =
            "85"
    in
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.x (String.fromInt point.x)
        , Svg.Attributes.y (String.fromInt point.y)
        , Svg.Attributes.width width
        , Svg.Attributes.height height
        , Svg.Attributes.viewBox
            ("0 0"
                ++ " "
                ++ width
                ++ " "
                ++ height
            )
        ]
        [ Svg.polygon
            [ Svg.Attributes.points
                ("20,0 20,170 "
                    ++ "20,170 0,150 "
                    ++ "0,150 0,0 "
                )
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x surfaceX
            , Svg.Attributes.y "0"
            , Svg.Attributes.width surfaceWidth
            , Svg.Attributes.height height
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x surfaceX
            , Svg.Attributes.y "0"
            , Svg.Attributes.width surfaceWidth
            , Svg.Attributes.height drawerHeight
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x surfaceX
            , Svg.Attributes.y drawerHeight
            , Svg.Attributes.width surfaceWidth
            , Svg.Attributes.height drawerHeight
            ]
            []
        ]
