module Images.BoxDoor exposing (defs, view)

import Constants.Color
import String exposing (toInt)
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Point
import Utils.Svg


openedId : String
openedId =
    "opened-box-door"


closedId : String
closedId =
    "closed-box-door"


view : Types.Object.Openable -> Types.Point.Point -> Svg msg
view obj { x, y } =
    case obj of
        Types.Object.Opened _ ->
            Svg.use
                [ Svg.Attributes.xlinkHref ("#" ++ openedId)
                , Svg.Attributes.x (String.fromInt x)
                , Svg.Attributes.y (String.fromInt y)
                , Svg.Attributes.fill Constants.Color.backgroundColor
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


sideSize : Int
sideSize =
    20


size : Types.Point.Size
size =
    { width = 170
    , height = 170
    }


surfaceSize : Types.Point.Size
surfaceSize =
    { width = size.width - sideSize
    , height = size.height - sideSize
    }


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


defOpened : Svg msg
defOpened =
    Utils.Svg.createSvg
        { x = 0, y = 0 }
        size
        []
        []


defClosed : Svg msg
defClosed =
    Utils.Svg.createSvg
        { x = 0, y = 0 }
        size
        []
        [ defDoorWithKey { x = 10, y = sideSize + 10 }
        ]


doorSize : Types.Point.Size
doorSize =
    { width = toFloat (surfaceSize.width - 30) / 2 |> floor
    , height = surfaceSize.height - 20
    }


defDoor : Types.Point.Point -> Svg msg
defDoor point =
    let
        size_ =
            doorSize
    in
    Utils.Svg.createSvg
        point
        size_
        []
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width (String.fromInt size_.width)
            , Svg.Attributes.height (String.fromInt size_.height)
            ]
            []
        ]


defDoorWithKey : Types.Point.Point -> Svg msg
defDoorWithKey point =
    let
        size_ =
            doorSize
    in
    Utils.Svg.createSvg
        point
        size_
        []
        [ defDoor { x = 0, y = 0 }
        , defKeyhole { x = 30, y = 100 }
        ]


defKeyhole : Types.Point.Point -> Svg msg
defKeyhole point =
    let
        size_ : Types.Point.Size
        size_ =
            { width = 24
            , height = 24
            }

        cx =
            toFloat size_.width
                / 2
                |> String.fromFloat

        cy =
            toFloat size_.width
                / 2
                |> String.fromFloat
    in
    Utils.Svg.createSvg
        point
        size_
        []
        [ Svg.circle
            [ Svg.Attributes.cx cx
            , Svg.Attributes.cy cy
            , Svg.Attributes.r "8"
            ]
            []
        , Svg.line
            [ Svg.Attributes.x1 "12"
            , Svg.Attributes.y1 "8"
            , Svg.Attributes.x2 "12"
            , Svg.Attributes.y2 "16"
            ]
            []
        ]
