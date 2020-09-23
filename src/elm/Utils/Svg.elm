module Utils.Svg exposing (createPolygonLine, createSvg, createViewBox)

import Html
import Svg exposing (Svg)
import Svg.Attributes
import Types.Shape


createPolygonPoint : Types.Shape.Point -> String
createPolygonPoint point =
    String.fromInt point.x
        ++ ","
        ++ String.fromInt point.y
        ++ " "


createPolygonLine : Types.Shape.Point -> Types.Shape.Point -> String
createPolygonLine start end =
    createPolygonPoint { x = start.x, y = start.y }
        ++ createPolygonPoint { x = end.x, y = end.y }


createViewBox :
    Types.Shape.Point
    -> Types.Shape.Size
    -> Svg.Attribute msg
createViewBox point size =
    Svg.Attributes.viewBox
        (" "
            ++ String.fromInt point.x
            ++ " "
            ++ String.fromInt point.y
            ++ " "
            ++ String.fromInt size.width
            ++ " "
            ++ String.fromInt size.height
        )


createSvg :
    Types.Shape.Point
    -> Types.Shape.Size
    -> List (Html.Attribute msg)
    -> List (Svg msg)
    -> Html.Html msg
createSvg point size attr svg =
    Svg.svg
        (List.append
            [ Svg.Attributes.version "1.1"
            , Svg.Attributes.x (String.fromInt point.x)
            , Svg.Attributes.y (String.fromInt point.y)
            , Svg.Attributes.width (String.fromInt size.width)
            , Svg.Attributes.height (String.fromInt size.height)
            , createViewBox { x = 0, y = 0 } size
            ]
            attr
        )
        svg
