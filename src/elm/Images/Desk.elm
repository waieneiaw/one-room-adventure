module Images.Desk exposing (defs, view)

import Constants.Color
import Constants.Wall
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Shape
import Utils.Svg


id : String
id =
    "desk"


view : Types.Object.Plain -> Types.Shape.Point -> Svg msg
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


size : Types.Shape.Size
size =
    { width = Constants.Wall.size.width
    , height = 300
    }


defs : Svg msg
defs =
    Svg.defs []
        [ Svg.g [ Svg.Attributes.id id ]
            [ defImpl
            ]
        ]


defImpl : Svg msg
defImpl =
    Utils.Svg.createSvg
        { x = 0, y = 0 }
        size
        []
        [ defLeftLeg { x = 50, y = 0 }
        , defRightLeg { x = 500, y = 0 }
        , defCabinet { x = 330, y = 60 }
        , defSurface { x = 0, y = 0 }
        ]


defSurface : Types.Shape.Point -> Svg msg
defSurface point =
    let
        size_ : Types.Shape.Size
        size_ =
            { width = Constants.Wall.innerSize.width + 64
            , height = 60
            }
    in
    Utils.Svg.createSvg
        point
        size_
        []
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "30"
            , Svg.Attributes.width (String.fromInt size_.width)
            , Svg.Attributes.height "30"
            ]
            []
        , Svg.polygon
            [ Svg.Attributes.points
                (Utils.Svg.createPolygonLine
                    { x = 32, y = 0 }
                    { x = 0, y = 30 }
                    ++ Utils.Svg.createPolygonLine
                        { x = 0, y = 30 }
                        { x = 600, y = 30 }
                    ++ Utils.Svg.createPolygonLine
                        { x = 578, y = 30 }
                        { x = 544, y = 0 }
                    ++ Utils.Svg.createPolygonLine
                        { x = 546, y = 0 }
                        { x = 32, y = 0 }
                )
            ]
            []
        ]


defLeftLeg : Types.Shape.Point -> Svg msg
defLeftLeg point =
    let
        legWidth =
            30

        legDepth =
            30

        size_ : Types.Shape.Size
        size_ =
            { width = 60
            , height = 230
            }
    in
    Utils.Svg.createSvg
        point
        size_
        []
        [ Svg.polygon
            [ Svg.Attributes.points
                (Utils.Svg.createPolygonLine
                    { x = legWidth, y = 0 }
                    { x = legWidth, y = size_.height }
                    ++ Utils.Svg.createPolygonLine
                        { x = legWidth, y = size_.height }
                        { x = size_.width, y = size_.height - legDepth }
                    ++ Utils.Svg.createPolygonLine
                        { x = size_.width, y = size_.height - legDepth }
                        { x = size_.width, y = 0 }
                )
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width (String.fromInt legWidth)
            , Svg.Attributes.height (String.fromInt size_.height)
            ]
            []
        ]


defRightLeg : Types.Shape.Point -> Svg msg
defRightLeg point =
    let
        size_ : Types.Shape.Size
        size_ =
            { width = 30
            , height = 230
            }
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


defCabinet : Types.Shape.Point -> Svg msg
defCabinet point =
    let
        surfaceX =
            20

        size_ : Types.Shape.Size
        size_ =
            { width = 170
            , height = 170
            }

        surfaceSize_ : Types.Shape.Size
        surfaceSize_ =
            { width = 150
            , height = 85
            }
    in
    Utils.Svg.createSvg
        point
        size_
        []
        [ Svg.polygon
            [ Svg.Attributes.points
                (Utils.Svg.createPolygonLine
                    { x = surfaceX, y = 0 }
                    { x = surfaceX, y = size_.height }
                    ++ Utils.Svg.createPolygonLine
                        { x = surfaceX, y = size_.height }
                        { x = 0, y = size_.height - surfaceX }
                    ++ Utils.Svg.createPolygonLine
                        { x = 0, y = size_.height - surfaceX }
                        { x = 0, y = 0 }
                )
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x (String.fromInt surfaceX)
            , Svg.Attributes.y (String.fromInt surfaceSize_.height)
            , Svg.Attributes.width (String.fromInt surfaceSize_.width)
            , Svg.Attributes.height (String.fromInt surfaceSize_.height)
            ]
            []
        ]
