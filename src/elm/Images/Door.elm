module Images.Door exposing (defs, view)

import Constants.Color
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Point


view : Types.Object.Openable -> Types.Point.Point -> Svg msg
view door { x, y } =
    let
        opened =
            case door of
                Types.Object.Opened _ ->
                    True

                _ ->
                    False

        xStr =
            String.fromInt x

        yStr =
            String.fromInt y
    in
    if opened then
        Svg.use
            [ Svg.Attributes.xlinkHref ("#" ++ openedId)
            , Svg.Attributes.x xStr
            , Svg.Attributes.y yStr
            , Svg.Attributes.stroke Constants.Color.mainColor
            ]
            []

    else
        Svg.use
            [ Svg.Attributes.xlinkHref ("#" ++ closedId)
            , Svg.Attributes.x xStr
            , Svg.Attributes.y yStr
            , Svg.Attributes.stroke Constants.Color.mainColor
            ]
            []


openedId : String
openedId =
    "opened-door"


closedId : String
closedId =
    "closed-door"


defs : Svg msg
defs =
    Svg.defs []
        [ Svg.g [ Svg.Attributes.id openedId ]
            [ defOpenedDoor
            ]
        , Svg.g [ Svg.Attributes.id closedId ]
            [ defClosedDoor
            ]
        ]


defOpenedDoor : Svg msg
defOpenedDoor =
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.width "300"
        , Svg.Attributes.height "300"
        , Svg.Attributes.viewBox "0 0 300 300"
        ]
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width "144"
            , Svg.Attributes.height "218"
            , Svg.Attributes.strokeWidth "1"
            ]
            []
        , Svg.line
            [ Svg.Attributes.y1 "0"
            , Svg.Attributes.x1 "100"
            , Svg.Attributes.y2 "190"
            , Svg.Attributes.x2 "100"
            , Svg.Attributes.strokeWidth "1"
            ]
            []
        , Svg.line
            [ Svg.Attributes.y1 "190"
            , Svg.Attributes.x1 "100"
            , Svg.Attributes.y2 "218"
            , Svg.Attributes.x2 "144"
            , Svg.Attributes.strokeWidth "1"
            ]
            []
        ]


defClosedDoor : Svg msg
defClosedDoor =
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.width "300"
        , Svg.Attributes.height "300"
        , Svg.Attributes.viewBox "0 0 300 300"
        ]
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width "144"
            , Svg.Attributes.height "218"
            , Svg.Attributes.strokeWidth "1"
            ]
            []
        , Svg.circle
            [ Svg.Attributes.r "8"
            , Svg.Attributes.cx "16"
            , Svg.Attributes.cy "120"
            , Svg.Attributes.strokeWidth "1"
            ]
            []
        ]
