module Types.Item exposing (Item, ItemType(..), noneValue)


type ItemType
    = None
    | Paper


type alias Item =
    { type_ : ItemType
    , name : String
    , weight : Int
    }


noneValue : Item
noneValue =
    { type_ = None
    , name = ""
    , weight = 0
    }
