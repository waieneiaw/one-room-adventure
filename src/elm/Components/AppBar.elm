module Components.AppBar exposing (view)

import Html exposing (Html)
import Html.Attributes


view : String -> Html msg
view title =
    Html.header [ Html.Attributes.class "ly_appbar" ]
        [ Html.nav [ Html.Attributes.class "ml_header_nav" ]
            [ Html.h1 [ Html.Attributes.class "ml_header_title" ]
                [ Html.text title ]
            ]
        ]
