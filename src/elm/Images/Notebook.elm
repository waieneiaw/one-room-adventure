module Images.Notebook exposing (defs, view)

import Constants.Color
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Point
import Utils.Svg


openedId : String
openedId =
    "opened-notebook"


closedId : String
closedId =
    "closed-notebook"


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


size : Types.Point.Size
size =
    { width = 80
    , height = 20
    }


pageSize : Types.Point.Size
pageSize =
    { width = 40
    , height = 20
    }


depth : Int
depth =
    6


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
        [ Svg.polygon
            [ Svg.Attributes.points
                (Utils.Svg.createPolygonLine
                    { x = depth, y = 0 }
                    { x = 0, y = pageSize.height }
                    ++ Utils.Svg.createPolygonLine
                        { x = 0, y = size.height }
                        { x = pageSize.width, y = pageSize.height }
                    ++ Utils.Svg.createPolygonLine
                        { x = pageSize.width, y = pageSize.height }
                        { x = pageSize.width - depth, y = 0 }
                )
            ]
            []
        ]


defOpened : Svg msg
defOpened =
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
                    ++ Utils.Svg.createPolygonLine
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
        , Svg.line
            [ Svg.Attributes.x1 (String.fromInt pageSize.width)
            , Svg.Attributes.y1 (String.fromInt 0)
            , Svg.Attributes.x2 (String.fromInt pageSize.width)
            , Svg.Attributes.y2 (String.fromInt size.height)
            ]
            []
        ]
