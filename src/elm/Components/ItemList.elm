module Components.ItemList exposing (view)

import Html exposing (Html)
import Html.Attributes
import Types.Item


viewListItem : Types.Item.Item -> Html msg
viewListItem item =
    Html.li []
        [ Html.text item.name
        ]


view : List Types.Item.Item -> Html msg
view items =
    Html.section [ Html.Attributes.class "ml_game_itemList" ]
        [ Html.span [] [ Html.text "item list" ]
        , Html.div [ Html.Attributes.class "ml_game_itemList_inner" ]
            [ Html.ul []
                (List.map viewListItem items)
            ]
        ]
