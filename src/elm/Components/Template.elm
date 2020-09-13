module Components.Template exposing
    ( Details
    , view
    )

import Browser
import Components.AppBar
import Components.Footer
import Html exposing (Html)
import Html.Attributes
import Images.Door
import Images.Paper
import Images.Wall
import Svg


title : String
title =
    "ONE ROOM ADVENTURE"


type alias Details msg =
    { title : String
    , children : List (Html msg)
    }


view : (a -> msg) -> Html a -> Browser.Document msg
view toMsg content =
    { title = title
    , body =
        [ Html.div [ Html.Attributes.class "ly_wrapper" ]
            [ Components.AppBar.view title
            , viewMain (Html.map toMsg <| content)
            , Components.Footer.view
            ]
        , Svg.defs []
            [ Images.Wall.defs
            , Images.Door.defs
            , Images.Paper.defs
            ]
        ]
    }


viewMain : Html msg -> Html msg
viewMain content =
    Html.main_ [ Html.Attributes.class "ly_main" ]
        [ Html.div [ Html.Attributes.class "ly_mainContent" ]
            [ Html.div [ Html.Attributes.class "ly_mainContent_inner" ]
                [ content
                ]
            ]
        ]
