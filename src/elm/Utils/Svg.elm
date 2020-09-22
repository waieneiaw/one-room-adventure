module Utils.Svg exposing (createPolygonLine, createSvg, createViewBox)

import Html
import Svg exposing (Svg)
import Svg.Attributes
import Types.Point


createPolygonPoint : Types.Point.Point -> String
createPolygonPoint point =
    String.fromInt point.x
        ++ ","
        ++ String.fromInt point.y
        ++ " "


createPolygonLine : Types.Point.Point -> Types.Point.Point -> String
createPolygonLine start end =
    createPolygonPoint { x = start.x, y = start.y }
        ++ createPolygonPoint { x = end.x, y = end.y }


createViewBox :
    Types.Point.Point
    -> Types.Point.Size
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
    Types.Point.Point
    -> Types.Point.Size
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
