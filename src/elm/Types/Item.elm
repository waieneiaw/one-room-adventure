module Types.Item exposing (Item, ItemType(..), Items, getItem, noneValue)


type ItemType
    = None
    | Paper
    | Key


type alias Item =
    { type_ : ItemType
    , name : String
    , weight : Int
    }


type alias Items =
    List Item


noneValue : Item
noneValue =
    { type_ = None
    , name = ""
    , weight = 0
    }


{-| 指定したtype\_のアイテムを持っている場合、そのアイテムを返す。
-}
getItem : Items -> ItemType -> Maybe Item
getItem list type_ =
    case list of
        [] ->
            Nothing

        item :: items ->
            if item.type_ == type_ then
                Just item

            else
                getItem items type_
