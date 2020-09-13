module Components.Footer exposing (view)

import Html exposing (Html)
import Html.Attributes


view : Html msg
view =
    Html.footer [ Html.Attributes.class "ly_footer" ]
        [ Html.div [ Html.Attributes.class "ml_footer_copyright" ]
            [ Html.span [] [ Html.text "© 2020 waien" ]
            ]
        ]
