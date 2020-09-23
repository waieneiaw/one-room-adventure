module Images.SafeDoor exposing (defs, view)

import Constants.Color
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Point
import Utils.Svg


openedId : String
openedId =
    "opened-safe-door"


closedId : String
closedId =
    "closed-safe-door"


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


defClosed : Svg msg
defClosed =
    Utils.Svg.createSvg
        { x = 0, y = 0 }
        size
        []
        [ defDoor { x = 10, y = sideSize + 10 }
        ]


defOpened : Svg msg
defOpened =
    Utils.Svg.createSvg
        { x = 0, y = 0 }
        size
        []
        []


defDoor : Types.Point.Point -> Svg msg
defDoor point =
    let
        size_ : Types.Point.Size
        size_ =
            { width = surfaceSize.width - 20
            , height = surfaceSize.height - 20
            }
    in
    Utils.Svg.createSvg
        point
        surfaceSize
        []
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width (String.fromInt size_.width)
            , Svg.Attributes.height (String.fromInt size_.height)
            ]
            []
        , Svg.circle
            [ Svg.Attributes.cx "20"
            , Svg.Attributes.cy "70"
            , Svg.Attributes.r "10"
            ]
            []
        ]
