module Images.Board exposing (defs, view)

import Constants.Color
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Point
import Utils.Svg


openedId : String
openedId =
    "opened-board"


closedId : String
closedId =
    "closed-board"


view : Types.Object.Openable -> Types.Point.Point -> Svg msg
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


size : Types.Point.Size
size =
    { width = 120
    , height = 120
    }


defClosed : Svg msg
defClosed =
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


defOpened : Svg msg
defOpened =
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
        ]
