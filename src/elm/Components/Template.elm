module Components.Template exposing
    ( Details
    , view
    )

import Browser
import Components.ImageDefs
import Html exposing (Html)
import Html.Attributes


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
            [ viewHeader
            , viewMain (Html.map toMsg <| content)
            , viewFooter
            ]
        , Components.ImageDefs.defs
        ]
    }


viewHeader : Html msg
viewHeader =
    Html.header [ Html.Attributes.class "ly_header" ]
        [ Html.nav [ Html.Attributes.class "ml_header_nav" ]
            [ Html.h1 [ Html.Attributes.class "ml_header_title" ]
                [ Html.text title ]
            ]
        ]


viewMain : Html msg -> Html msg
viewMain content =
    Html.main_ [ Html.Attributes.class "ly_main" ]
        [ Html.div [ Html.Attributes.class "ly_mainContent" ]
            [ Html.div [ Html.Attributes.class "ly_mainContent_inner" ]
                [ content
                ]
            ]
        ]


viewFooter : Html msg
viewFooter =
    Html.footer [ Html.Attributes.class "ly_footer" ]
        [ Html.div [ Html.Attributes.class "ml_footer_copyright" ]
            [ Html.span [] [ Html.text "© 2020 waien" ]
            ]
        ]
