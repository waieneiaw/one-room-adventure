module Images.Machine exposing (defs, view)

import Constants.Color
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Shape


openedId : String
openedId =
    "opened-machine"


closedId : String
closedId =
    "closed-machine"


view : Types.Object.Openable -> Types.Shape.Point -> Svg msg
view obj { x, y } =
    case obj of
        Types.Object.Opened _ ->
            Svg.use
                [ Svg.Attributes.xlinkHref ("#" ++ openedId)
                , Svg.Attributes.x (String.fromInt x)
                , Svg.Attributes.y (String.fromInt y)
                , Svg.Attributes.fill Constants.Color.backgroundColor
                , Svg.Attributes.fillOpacity "0"
                , Svg.Attributes.stroke Constants.Color.mainColor
                ]
                []

        _ ->
            Svg.use
                [ Svg.Attributes.xlinkHref ("#" ++ closedId)
                , Svg.Attributes.x (String.fromInt x)
                , Svg.Attributes.y (String.fromInt y)
                , Svg.Attributes.fill Constants.Color.backgroundColor
                , Svg.Attributes.stroke Constants.Color.mainColor
                ]
                []


defs : Svg msg
defs =
    Svg.defs []
        [ Svg.g [ Svg.Attributes.id openedId ]
            [ defOpened
            ]
        , Svg.g [ Svg.Attributes.id closedId ]
            [ defClosed
            ]
        ]


defClosed : Svg msg
defClosed =
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.width "120"
        , Svg.Attributes.height "40"
        , Svg.Attributes.viewBox "0 0 120 40"
        ]
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width "120"
            , Svg.Attributes.height "40"
            ]
            []
        , defCounter { x = 10, y = 10 }
        , defCounter { x = 30, y = 10 }
        , defCounter { x = 50, y = 10 }
        , defCounter { x = 70, y = 10 }
        , Svg.circle
            [ Svg.Attributes.cx "110"
            , Svg.Attributes.cy "20"
            , Svg.Attributes.r "5"
            ]
            []
        ]


defCounter : Types.Shape.Point -> Svg msg
defCounter point =
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.x (String.fromInt point.x)
        , Svg.Attributes.y (String.fromInt point.y)
        ]
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width "10"
            , Svg.Attributes.height "20"
            ]
            []
        ]


defOpened : Svg msg
defOpened =
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.width "120"
        , Svg.Attributes.height "40"
        , Svg.Attributes.viewBox "0 0 120 40"
        ]
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width "120"
            , Svg.Attributes.height "40"
            ]
            []
        ]
