module Images.Paper exposing (defs, view)

import Constants.Color
import Svg exposing (Svg)
import Svg.Attributes
import Types.Object
import Types.Point


id : String
id =
    "paper"


view : Types.Object.Object -> Types.Point.Point -> Svg msg
view obj { x, y } =
    case obj of
        Types.Object.Exist _ ->
            Svg.use
                [ Svg.Attributes.xlinkHref ("#" ++ id)
                , Svg.Attributes.x (String.fromInt x)
                , Svg.Attributes.y (String.fromInt y)
                , Svg.Attributes.fill Constants.Color.backgroundColor
                , Svg.Attributes.stroke Constants.Color.mainColor
                ]
                []

        _ ->
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
        , Svg.Attributes.width "52"
        , Svg.Attributes.height "72"
        , Svg.Attributes.viewBox "0 0 52 72"
        ]
        [ Svg.rect
            [ Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.width "50"
            , Svg.Attributes.height "70"
            ]
            []
        ]
